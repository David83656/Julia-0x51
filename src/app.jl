# Import Pkg and check for required packages
import Pkg
Pkg.instantiate()

# Function to ensure that a package is installed
function ensure_installed(pkg_name::String)
    installed = any(dep.name == pkg_name && dep.is_direct_dep for dep in values(Pkg.dependencies()))
    if !installed
        Pkg.add(pkg_name)
    end
end
required_packages = ["Oxygen", "HTTP", "JSON", "StructTypes", "TextAnalysis"]
for pkg in required_packages
    ensure_installed(pkg)
end

# Import required packages
using Oxygen, HTTP, JSON, StructTypes, TextAnalysis

# Routes
include("routes.jl")
using .Routes

serve(PORT=8080)