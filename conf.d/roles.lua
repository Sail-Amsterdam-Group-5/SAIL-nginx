role_rules = {
    -- FAQ endpoints
    faq = {
        ["POST /faqs"] = {"admin"},
        ["PUT /faqs/.+/.+"] = {"admin"},
        ["DELETE /faqs/.+/.+"] = {"admin"},
        ["POST /faqs/.+/.+/click"] = {"volunteer"},
        ["GET /faqs"] = {"volunteer"},
        ["GET /faqs\\?category=.+"] = {"volunteer"},
        ["GET /faqs/.+/.+"] = {"volunteer"}
    },

    -- Map endpoints
    map = {
        ["POST /utilities"] = {"admin"},
        ["GET /utilities"] = {"volunteer"},
        ["GET /utilities/byid/.+"] = {"volunteer"},
        ["GET /utilities/findByTypeAndOrDate"] = {"volunteer"},
        ["PATCH /utilities/.+"] = {"admin", "team-lead"},
        ["DELETE /utilities/.+"] = {"admin"},
        ["POST /locations"] = {"admin"},
        ["GET /locations"] = {"volunteer"},
        ["GET /locations/.+"] = {"volunteer"},
        ["PATCH /locations/.+"] = {"admin"},
        ["DELETE /locations/.+"] = {"admin"},
    },

    -- User endpoints
    user = {
        ["GET /users"] = {"volunteer"},
        ["GET /users/.+"] = {"team-lead"},
        ["POST /register"] = {"volunteer"},
    }
}