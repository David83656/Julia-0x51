module GraphicsAnalysis


using DataFrames
using XLSX 
using Plots
using StatsBase


function generate_word_graph(xlsx_file, sheet_name)
    # Read the Excel file (updated to directly convert to DataFrame)
    df = DataFrame(XLSX.readtable(xlsx_file, sheet_name,infer_eltypes=true))

    keywords = df[!, "Palabras clave"]
    values = df[!, "Valor"]

    color = "blue"

    p = scatter(values, seriestype=:scatter, title="Frecuencia de Palabras", 
                xlabel="Palabras", ylabel="Valor",
                color=color, markersize=8, legend=false) 

    for (i, word) in enumerate(keywords)
        annotate!(p, (i, values[i] + 0.2, )) 
    end

    xticks!(1:length(keywords), keywords, rotation=45)

    println("Word graph generated")

    savefig(p, "word_graph.png") 
end

end