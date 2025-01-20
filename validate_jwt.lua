local jwt = require "resty.jwt"
local validators = require "resty.jwt-validators"

local function validate_jwt(service, role_rules)
    -- Load public key
    local public_key = io.open("/etc/secrets/keycloak-public-key", "r"):read("*a")
    if not public_key then
        ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
        ngx.say('{"error": "Unable to load public key"}')
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- Extract Auth header
    local auth_header = ngx.var.http_authorization
    if not auth_header or not string.find(auth_header, "Bearer") then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say('{"error": "Authorization header is missing or invalid"}')
        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- Extract token
    local token = string.gsub(auth_header, "Bearer ", "")

    -- Decode and validate token
    local jwt_obj = jwt:verify(public_key, token, {})

    if not jwt_obj.verified then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say('{"error": "Invalid token"}')
        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- Check if token is expired
    local claims = jwt_obj.payload

    local exp = claims["exp"]
    if exp and os.time() > exp then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.say('{"error": "Token has expired"}')
        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- Exctract claims
    local roles = claims["realm_access"]["roles"] or {}

    local id = claims["sub"]
    local name = claims["name"]
    local groupId = claims["groupId"]
    local user_function = claims["function"]
    local notificationPreference = claims["notificationPreference"]

    ngx.log(ngx.DEBUG, "Roles: ", table.concat(roles, ", "))
    ngx.log(ngx.DEBUG, "ID: ", id)
    ngx.log(ngx.DEBUG, "Name: ", name)
    ngx.log(ngx.DEBUG, "Group ID: ", groupId)
    ngx.log(ngx.DEBUG, "Function: ", user_function)
    ngx.log(ngx.DEBUG, "Notification Preference: ", notificationPreference)

    -- Determine endpoint and method
    local method = ngx.var.request_method
    local uri = ngx.var.uri
    local query = ngx.var.is_args .. (ngx.var.args or "")
    local endpoint = method .. " " .. uri .. query

    ngx.log(ngx.DEBUG, "Method: ", method)
    ngx.log(ngx.DEBUG, "URI: ", uri)
    ngx.log(ngx.DEBUG, "Query: ", query)
    ngx.log(ngx.DEBUG, "Endpoint: ", endpoint)

    -- Match against role role rules
    local allowed_roles = nil
    for pattern, required_roles in pairs(role_rules[service]) do
        if string.match(endpoint, pattern) then
            allowed_roles = required_roles
            break
        end
    end

    if not allowed_roles then
        ngx.status = ngx.HTTP_FORBIDDEN
        ngx.say('{"error": "Endpoint not allowed"}')
        return ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    -- Check if user has required roles
    local role_found = false
    for _, role in ipairs(roles) do
        for _, allowed_role in ipairs(allowed_roles) do
            if role == allowed_role then
                role_found = true
                break
            end
        end
        if role_found then
            break
        end
    end

    -- Forward request with claims in header
    ngx.req.set_header("X-User-Roles", table.concat(roles, ","))
    ngx.req.set_header("X-User-Id", id)
    ngx.req.set_header("X-User-Name", name)
    ngx.req.set_header("X-User-GroupId", groupId)
    ngx.req.set_header("X-User-Function", user_function)
    ngx.req.set_header("X-User-NotificationPreference", notificationPreference)
    
    --CORS
    ngx.header("Access-Control-Allow-Origin: *")
    ngx.header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS")
    ngx.header("Access-control-Allow-Headers: Content-Type, Authorization")


end

return validate_jwt