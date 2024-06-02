# Import Pkg and check for required packages
import Pkg

# Using other modules
include("analysis.jl") 

# Function to ensure that a package is installed
function ensure_installed(pkg_name::String)
    installed = any(dep.name == pkg_name && dep.is_direct_dep for dep in values(Pkg.dependencies()))
    if !installed
        Pkg.add(pkg_name)
    end
end
required_packages = ["Oxygen", "HTTP", "JSON", "StructTypes", "TextAnalysis","Flux"]
for pkg in required_packages
    ensure_installed(pkg)
end

# Import required packages
using Oxygen, HTTP, JSON, StructTypes, TextAnalysis

# Call the model training function
modtrain.mi_funcion()

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