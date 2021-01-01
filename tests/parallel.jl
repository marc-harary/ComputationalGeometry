"""Determines whether two linear objects are parallel"""
function parallel(l1::AbstractLine, l2::AbstractLine)::Bool
    l1.direction == l2.direction
end

"""Determines whether linear object and plane are parallel"""
function parallel(l::AbstractLine3, pl::Plane)::Bool
    dot(l.direction, pl.normal) == 0
end