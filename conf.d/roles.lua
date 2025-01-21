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
        ["GET /swagger/index.html"] = {"volunteer"},
    },

    schedule = {
        ["GET /"] = {"volunteer"},
        ["GET /.+"] = {"volunteer"},
        ["GET /group/.+"] = {"volunteer"},
        ["POST /task"] = {"team-lead"},
        ["GET /task/.+"] = {"volunteer"},
        ["PUT /task/.+"] = {"team-lead"},
        ["DELETE /task/.+"] = {"team-lead"},
        ["POST /task/.+/checkin"] = {"volunteer"},
        ["POST /task/.+/cancel"] = {"volunteer"},
        ["GET /task/checkins"] = {"team-lead"},
        ["GET /task/checknins/.+/.+"] = {"volunteer"},
        -- ["GET /task/"],
    }, 

    -- Chat endpoints
    chat = {
        ["GET /api/Chats/.+"] = {"volunteer"},
        ["POST /api/Chats"] = {"volunteer"},
        ["GET /api/Chats"] = {"volunteer"},
        ["POST /api/Chats/.+/users/.+"] = {"volunteer"},
        ["DELETE /api/Chats/.+/users/.+"] = {"volunteer"},
        ["POST /api/Chats/.+/admin/.+"] = {"admin", "team-lead"},
        ["DELETE /api/Chats/.+/admin/.+"] = {"admin", "team-lead"},
        ["GET /api/Messages/.+"] = {"volunteer"},
        ["GET /api/Messages/deleted"] = {"volunteer"},
        ["POST /api/Messages"] = {"volunteer"},
        ["DELETE /api/Messages/.+"] = {"volunteer"},
        ["GET /api/Messages/metrics/system"] = {"volunteer"},
        ["GET /api/Messages/.+/sync"] = {"volunteer"},
        ["GET /api/Messages/.+/recent"] = {"volunteer"},
        ["GET /api/Messages/.+/history"] = {"volunteer"},
        ["GET /swagger/index.html"] = {"volunteer"},
    }
}