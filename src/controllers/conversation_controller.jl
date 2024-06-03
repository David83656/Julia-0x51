module ConversationController

using HTTP
using JSON
include("../services/conversation_service.jl")
using .ConversationService

# Dummy index function for testing
function index(req::HTTP.Request)
    return HTTP.Response(200, "conversation index!")
end

function store_conversation(req::HTTP.Request)
    println("Create Conversation")
    data = JSON.parse(String(req.body))
    conversation = data["conversation"]
    result = ConversationService.analyze_conversation(conversation)
    return HTTP.Response(200, JSON.json(result))
end

function test_huggingface(req::HTTP.Request)
    result = ConversationService.test_huggingface_connection()
    return HTTP.Response(200, JSON.json(result))
end

end
