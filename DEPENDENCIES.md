# How to install dependencies - Julia

## Install Julia
```bash
sudo apt-get install julia
```
or download from [Julia's website](https://julialang.org/downloads/)

## Install dependencies
```julia
using Pkg
Pkg.add("<package>")
```

## To run the application, simply execute
```julia
julia app.jl
```
The app will automatically download the necessary dependencies.