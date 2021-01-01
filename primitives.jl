using MeshIO
using FileIO
using GeometryBasics: Mesh, TriangleP, Ngon, Point, AbstractPoint
using StaticArrays
using LinearAlgebra

const Triangle3 = TriangleP{3}
const INF3 = Point(Inf,Inf,Inf)

abstract type AbstractLine{Dim,P<:AbstractPoint{Dim}} end 

const AbstractLine3 = AbstractLine{3}

struct Ray{Dim,P} <: AbstractLine{Dim,P}
    start_point::P
    direction::SVector{Dim,Float64}
    function Ray(p1::P, p2::P) where {Dim,P<:AbstractPoint{Dim,<:Real}}
        diff = p2 - p1
        sd = SVector(diff...) |> normalize
        new{Dim,typeof(p1)}(p1, sd)
    end
    function Ray(p::AbstractVector{<:Real}, d::AbstractVector{<:Real})
        (Dim = length(p)) == length(d) || error("`p` and `d` must be the same length")
        sp = Point(p...)
        sd = SVector(d...) |> normalize
        new{Dim,typeof(sp)}(sp, sd)
    end
end

function Ray(l::AbstractLine{Dim,P}) where {Dim,P<:AbstractPoint{Dim}}
    Ray(l.start_point, l.direction)
end

function (r::Ray{Dim,V})(t::Real)::V where {Dim,V<:AbstractVector{<:Real}}
    t > 0 ? r.start_point + r.direction * t : INF3
end

const Ray3 = Ray{3}

struct Line{Dim,P} <: AbstractLine{Dim,P}
    start_point::P
    direction::SVector{Dim,Float64} where Dim
    """Defines line from two points, calculating the normalized direction"""
    function Line(p1::P, p2::P) where {Dim,P<:AbstractPoint{Dim,<:Real}}
        diff = p2 - p1
        sd = SVector(diff...) |> normalize
        new{Dim,typeof(p1)}(p1, sd)
    end
    """Defines line from two arrays, assuming latter is direction"""
    function Line(p::AbstractVector{<:Real}, d::AbstractVector{<:Real})
        (Dim = length(p)) == length(d) || error("`p` and `d` must be the same length")
        sp = Point(p...)
        sd = SVector(d...) |> normalize
        new{Dim,typeof(sp)}(sp, sd)
    end
end

"""Converts linear object to line"""
function Line(l::AbstractLine{Dim,P}) where {Dim,P<:AbstractPoint{Dim}}
    Line(l.start_point, l.direction)
end

"""Makes Line object a callable parametric object"""
function (l::Line{Dim,P})(t::Real)::P where {Dim,P<:AbstractVector{<:Real}}
    l.start_point + l.direction * t
end

const Line3 = Line{3}

struct Segment{Dim,P} <: AbstractLine{Dim,P}
    start_point::P
    end_point::P
    direction::SVector{Dim,Float64}
    """Constructs Segment from two points and direction vector"""
    function Segment(p1::P, p2::P, d::AbstractVector{<:Real}) where {Dim,P<:AbstractPoint{Dim,<:Real}}
        d == p2 - p1 ? new{Dim,P}(p1, p2, normalize(d)) : error("Direction and points must be collinear")
    end
end

"""Constructs segment from two points"""
function Segment(p1::P, p2::P) where {Dim,P<:AbstractPoint{Dim,<:Real}}
    Segment(p1, p2, SVector(p2 .- p1))
end

"""Constructs segment from any two abstract vectors, assuming they represent points"""
function Segment(p1::V, p2::V) where V<:AbstractVector{<:Real}
    Segment(Point(p1...), Point(p2...))
end

const Segment3 = Segment{3}

struct Plane{Dim,P<:AbstractPoint{Dim}}
    start_point::P
    normal::SVector{Dim,Float64}
end

"""Constructs Plane from start point and normal vector"""
function Plane(sp::AbstractPoint{Dim,<:Real}, normal::AbstractVector{<:Real}) where Dim
    Plane(sp, normal)
end

"""Constructs Plane from three points"""
function Plane(p1::P, p2::P, p3::P) where {Dim,P<:AbstractPoint{Dim,<:Real}}
    normal = cross(p3 - p1, p3 - p2) |> normalize
    d = dot(p1, normal)
    Plane(p1, normal)
end

"""Constructs supporting plane of triangle"""
function Plane(tri::Triangle3) 
    Plane(tri...)
end
