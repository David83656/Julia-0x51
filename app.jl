using Oxygen
using HTTP
using JSON
using StructTypes
using TextAnalysis
using PyCall


#CRUD API

#Struct to store conversations
struct ConversationAnalysis
    id::Int
    dialog::String
    sentiment::String
    keywords::String

end

#JSON support
StructTypes.StructType(::Type{ConversationAnalysis}) = StructTypes.Struct()

#Analyze of the conversation
function analyze_conversation(conversation::String)
    #TODO Implement conversation analysis
    
    return ConversationAnalysis(id, conversation, "Positive", "AI, Julia, Oxygen")
end

function analyze_dialog(conversation::String)
    #TODO Implement dialog analysis
    return ConversationAnalysis(id, conversation, "Positive", "AI, Julia, Oxygen")
end

function analyze_sentiments(conversation::String)
    #TODO Implement sentiment analysis
    return ConversationAnalysis(id, conversation, sentiment, "AI, Julia, Oxygen")
end


@post "/api/v1/store-conversation" function (req::HTTP.Request)

    println("Create Conversation")
    
    data=JSON.parse(String(HTTP.payload(req)))
    conversation = data["conversation"]
    result = analyze_conversation(conversation)
    println(data)
    return JSON.json(result)
    return data

end

serve(PORT=8080)


