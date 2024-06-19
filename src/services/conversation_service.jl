module ConversationService

using StructTypes
using CSV
using DataFrames
using XLSX
struct ConversationAnalysis
    id::Int
    dialog::String
    sentiment::String
    keywords::String
end

StructTypes.StructType(::Type{ConversationAnalysis}) = StructTypes.Struct()

# Listas extendidas de palabras positivas y negativas
const positive_words = CSV.read("src/services/datasets/positive_words.csv", DataFrame, header=false)
const negative_words = CSV.read("src/services/datasets/negative_words.csv", DataFrame, header=false)
const stop_words = CSV.read("src/services/datasets/stop_words.csv", DataFrame, header=false)

# Columna 1 del dataset
positive_words_vector = positive_words[!, 1]
negative_words_vector = negative_words[!, 1]
stop_words_vector = stop_words[!, 1]

# Función para analizar la conversación
function analyze_conversation(conversation::String)::ConversationAnalysis
    id=1
    sentiment = analyze_sentiment(conversation)
    keywords = extract_keywords(conversation, sentiment)
    keywords_string= join(keywords, ", ")
    return ConversationAnalysis(id,conversation,sentiment, keywords_string)
end

# Ahora `negative_words` es un vector de cadenas, donde cada cadena es una línea del archivo CSV.
# Función para analizar el sentimiento
function analyze_sentiment(conversation::String)::String
    pos_count = count(word -> lowercase(word) in positive_words_vector, split(conversation, r"\W+"))
    neg_count = count(word -> lowercase(word) in negative_words_vector, split(conversation, r"\W+"))
    
    if pos_count > neg_count
        return "Positive"
    elseif neg_count > pos_count
        return "Negative"
    else
        return "Neutral"
    end
end
# Función para extraer palabras clave (tokenización manual)
function extract_keywords(conversation::String, sentiment::String)::Vector{String}
    words = split(conversation, r"\W+")
    words = filter(w -> !(w in stop_words_vector) && length(w) > 2, lowercase.(words))
    
    words = map(stem_spanish, words)

    # Contar palabras
    word_counts = Dict{String, Int}()
    for word in words
        word_counts[word] = get(word_counts, word, 0) + 1
    end
    # Ordenar y tomar las palabras clave más frecuentes
    sorted_words = sort(collect(word_counts), by=last, rev=true)
    top_keywords = first.(sorted_words[1:min(500, length(sorted_words))])

    # Escribir las top_keywords en un archivo de Excel
    XLSX.openxlsx("src/services/plot_data/top_keywords.xlsx", mode="w") do xf
        sheet = xf[1]
        sheet["A1"] = "Palabras clave"
        sheet["B1"] = "Sentimiento encontrado"
        sheet["C1"] = "Valor"  # Add a new column header for the value
    
        # Find the length of the longest keyword
        max_length = maximum(length.(top_keywords))
    
        for (i, keyword) in enumerate(top_keywords)
            sheet["A$(i+1)"] = keyword
            sheet["B$(1)"] = sentiment
            value = length(keyword) / max_length
            sheet["C$(i+1)"] = value
        end
    end
    return top_keywords
end




function stem_spanish(word::String)::String
    # 1. Normalización
    word = lowercase(word)  # Convertir a minúsculas
    word = replace(word, r"[áéíóúü]" => s -> lowercase(s[1]))  # Quitar acentos

    # 2. Reglas generales de sufijos
    rules = [
        (r"s$", ""),          # Plurales regulares
        (r"es$", ""),         # Plurales en -es
        (r"mente$", ""),      # Adverbios en -mente
        (r"idad$", ""),       # Sustantivos abstractos en -idad
        (r"amente$", ""),     # Adverbios en -amente
        (r"able$", ""),       # Adjetivos en -able
        (r"ible$", ""),       # Adjetivos en -ible
        (r"mente$", ""),      # Adverbios en -mente
        (r"iva$", ""),       # Adjetivos en -iva
        (r"ivo$", ""),       # Adjetivos en -ivo
        (r"oso$", ""),       # Adjetivos en -oso
        (r"osa$", ""),       # Adjetivos en -osa
        (r"ísimo$", ""),      # Superlativos en -ísimo
        (r"ísima$", ""),      # Superlativos en -ísima
        (r"amente$", ""),     # Adverbios en -amente
    ]

    for (suffix, replacement) in rules
        if endswith(word, suffix)
            word = replace(word, suffix => replacement)
            break
        end
    end

    # 3. Reglas específicas para verbos
    verb_rules = [
        (r"ando$", ""),       # Gerundio
        (r"iendo$", ""),      # Gerundio
        (r"yendo$", "ir"),    # Gerundio irregular (yendo -> ir)
        (r"ar$", ""),        # Infinitivo
        (r"er$", ""),        # Infinitivo
        (r"ir$", ""),        # Infinitivo
        (r"aba$", ""),       # Copretérito
        (r"ábamos$", ""),     # Copretérito
        (r"ía$", ""),        # Condicional
        (r"íamos$", ""),     # Condicional
        (r"ase$", ""),       # Subjuntivo imperfecto
        (r"ásemos$", ""),    # Subjuntivo imperfecto
        (r"ara$", ""),       # Subjuntivo imperfecto
        (r"áramos$", ""),    # Subjuntivo imperfecto
        (r"ase$", ""),       # Subjuntivo imperfecto
        (r"ásemos$", ""),    # Subjuntivo imperfecto
        (r"aron$", ""),      # Pretérito indefinido
        (r"aste$", ""),      # Pretérito indefinido
        (r"ó$", ""),         # Pretérito indefinido
        (r"amos$", ""),      # Pretérito indefinido
        (r"asteis$", ""),    # Pretérito indefinido
        (r"aron$", ""),      # Pretérito indefinido
    ]

    for (suffix, replacement) in verb_rules
        if endswith(word, suffix)
            word = replace(word, suffix => replacement)
            # Manejo de irregularidades en verbos con "gu"
            if endswith(word, "gu") && replacement == ""
                word *= 'e'  # "llegar" -> "llegue"
            end
            break
        end
    end

    return word
end
end 
