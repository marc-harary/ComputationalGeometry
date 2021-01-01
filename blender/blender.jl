"""Wraps Blender to produce mesh of geometric primitives"""
function make_primitive(;solid::Union{Symbol,String},
                         blender_path::String="/blender/blender",
                         script_path::String="$(@__DIR__)/blender.py",
                         output_path::String="temp.obj",
                         keep::Bool=false,
                         kwargs...)::TriangleMesh{3}
    cmd = [blender_path,
           "--background",
           "--python",
           script_path,
           "--",
           "--filepath=$output_path",
           "--solid=$solid"]
    for (key, value) in kwargs
        value = filter(x -> !(x in "( )"), string(value))
        push!(cmd, "--$key=$value")
    end
    run(`$cmd`)
    mesh = load("$output_path")
    if !keep
        basename = split(output_path, ".") |> first
        run(`rm $output_path $basename.mtl`)
    end
    mesh
end
