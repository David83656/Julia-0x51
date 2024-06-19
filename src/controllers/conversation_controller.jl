module ConversationController

using HTTP
using JSON
using StatsBase
include("../services/conversation_service.jl")
include("../services/analytics-graphics.jl")
using .ConversationService
using .GraphicsAnalysis

# Dummy index function for testing
function index(req::HTTP.Request)
    return HTTP.Response(200, "conversation index!")
end

function initiate_pipeline(req::HTTP.Request)
    println("Create Conversation")
    data = JSON.parse(String(req.body))
    conversation = data["conversation"]
    result = ConversationService.analyze_conversation(conversation)
    println("Conversation analyzed")
    GraphicsAnalysis.generate_word_graph("src/services/plot_data/top_keywords.xlsx", "Sheet1")
    return HTTP.Response(200, JSON.json(result))
end

end
