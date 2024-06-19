module Routes

using HTTP
using Oxygen
include("controllers/conversation_controller.jl")
using .ConversationController

@post "/api/v1/analyze-conversation" function (req::HTTP.Request)
    ConversationController.initiate_pipeline(req)
end

@get "/conversation/index" function (req::HTTP.Request)
    ConversationController.index(req)
end


end