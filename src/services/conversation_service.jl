module ConversationService

using StructTypes

struct ConversationAnalysis
    id::Int
    dialog::String
    sentiment::String
    keywords::String
end

StructTypes.StructType(::Type{ConversationAnalysis}) = StructTypes.Struct()

function analyze_conversation(conversation::String)
    # análisis de conversación
    id = 1  # Ejemplo de ID
    sentiment = "Positive"  # Lógica de ejemplo
    keywords = "AI, Julia, Oxygen"
    return ConversationAnalysis(id, conversation, sentiment, keywords)
end

end
