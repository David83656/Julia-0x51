module Routes

using HTTP
using Oxygen
include("controllers/conversation_controller.jl")
using .ConversationController

@post "/api/v1/store-conversation" function (req::HTTP.Request)
    ConversationController.store_conversation(req)
end

@get "/conversation/index" function (req::HTTP.Request)
    ConversationController.index(req)
end

end