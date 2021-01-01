"""Determines whether point lies on ray"""
function in(p::AbstractPoint{Dim}, r::Ray{Dim,<:AbstractPoint{Dim}})::Bool where Dim
    function f!(F, t)
        F[1] = norm(r(first(t)) - p)
    end
    res = nlsolve(f!, rand(1))
    converged(res) && first(res.zero) >= 0
end

"""Determines whether point lies on line"""
function in(p::AbstractPoint{Dim}, l::Line{Dim,<:AbstractPoint{Dim}})::Bool where Dim
    function f!(F, t)
        F[1] = norm(l(first(t)) - p)
    end
    converged(nlsolve(f!, rand(1)))
end

"""Determines whether point lies on segment"""
function in(p::AbstractPoint{Dim}, l::Segment{Dim,<:AbstractPoint{Dim}})::Bool where Dim
    p in Line(l) && 
    all(((p .> l.start_point) .& (p .< l.end_point)) .|
        ((p .< l.start_point) .& (p .> l.end_point)))
end

"""Determines whether point lies on plane"""
function in(pt::AbstractPoint{Dim}, pl::Plane{Dim})::Bool where Dim
    dot(pt, pl.normal) == dot(pl.start_point, pl.normal)
end

"""Determines whether linear object lies on plane"""
function in(l::AbstractLine, pl::Plane)::Bool
    parallel(l, pl) && l.start_point in pl
end

"""Determines whether point lies inside 3D triangle"""
function in(pt::Point3, tri::Triangle3)::Bool
    pl = Plane(tri)
    pt in pl &&
    dot(cross(b - a, q - a), pl.normal) >= 0 &&
    dot(cross(c - b, q - b), pl.normal) >= 0 &&
    dot(cross(a - c, q - c), pl.normal) >= 0
end