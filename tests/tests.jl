include("primitives.jl")
using NLsolve
using GeometryBasics
import Base.in

"""Returns eges of triangle"""
function edges(tri::TriangleP{Dim})::Tuple{Segment{Dim},Segment{Dim},Segment{Dim}} where Dim
    a, b, c = tri
    Segment(a, b), Segment(b, c), Segment(c, a)
end

include("paralle.jl")
include("in.jl")
include("closest.jl")
include("inter.jl")