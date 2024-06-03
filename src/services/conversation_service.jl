module ConversationService

using HTTP
using JSON
using StructTypes

struct ConversationAnalysis
    id::Int
    dialog::String
    sentiment::String
    keywords::String
end

StructTypes.StructType(::Type{ConversationAnalysis}) = StructTypes.Struct()

const HUGGINGFACE_API_URL = "https://api-inference.huggingface.co/models/distilbert-base-uncased-finetuned-sst-2-english"
const HUGGINGFACE_TOKEN = ENV["HUGGINGFACE_TOKEN"]

function get_sentiment(text::String)
    headers = [
        "Authorization" => "Bearer $HUGGINGFACE_TOKEN",
        "Content-Type" => "application/json"
    ]
    payload = JSON.json(Dict("inputs" => text))
    response = HTTP.post(HUGGINGFACE_API_URL, headers, payload)
    return JSON.parse(String(response.body))
end

function analyze_conversation(conversation::String)
    sentiment_response = get_sentiment(conversation)
    sentiment = sentiment_response[1]["label"]
    keywords = "AI, Julia, Oxygen"  # Puedes implementar una lógica para extraer keywords
    return ConversationAnalysis(1, conversation, sentiment, keywords)
end

function test_huggingface_connection()
    headers = [
        "Authorization" => "Bearer $HUGGINGFACE_TOKEN",
        "Content-Type" => "application/json"
    ]
    payload = JSON.json(Dict("inputs" => "Im happy to see you, buddy."))
    response = HTTP.post(HUGGINGFACE_API_URL, headers, payload)
    return JSON.parse(String(response.body))
end

end
