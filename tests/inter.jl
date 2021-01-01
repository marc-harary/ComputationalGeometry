"""Returns intersection of two linear objects.
N.B.: If parallel, the point on L2 closest to the origin of L1 is returned."""
function inter(l1::AbstractLine3, l2::AbstractLine3; epsilon::Float64=1e-5)::Point3
    s1, d1 = l1.start_point, l1.direction
    s2, d2 = l2.start_point, l2.direction
    if parallel(l1, l2)
        if !(s1 in l2)
            return INF3
        elseif l2 isa Segment3 && !(l1 isa Segment3)
            dist1, dist2 = norm(s2 - s1), norm(l2.end_point - s1)
            return dist1 < dist2 ? s2 : l2.end_point
        elseif l1 isa Segment3 && !(l2 isa Segment3)
            dist1, dist2 = norm(s2 - s1), norm(l2.end_point - s1)
            return dist1 < dist2 ? s2 : l2.end_point
        else
            return l1.start_point
        end
    end
    function f!(F, v)
        F = s1 + v[1] * d1 - s2 - v[2] * d2
    end
    res = nlsolve(f!, rand(2))
    if !converged(res) return INF3 end
    s, t = res.zero
    p1, p2 = l1(s), l2(t)
    if (l1 isa Ray3 && s < 0) ||
       (l2 isa Ray3 && t < 0) ||
       (l1 isa Segment3 && !(p1 in l1)) ||
       (l2 isa Segment3 && !(p2 in l2)) ||
       norm(p1 - p2) < epsilon
       return INF3
    end
    p1
end

"""Returns intersection of linear object and plane"""
function inter(l::AbstractLine3, pl::Plane)::Point3
    if parallel(l, pl)
        return l in pl ? l.start_point : INF3
    end
    t = dot((pl.start_point - l.start_point), pl.normal) / dot(l.direction, pl.normal)
    cand = Line(l)(t)
    return cand in l ? cand : INF3
end

"""Returns intersection of ray and triangle"""
function inter(l::AbstractLine3, tri::Triangle3)::Point3 where T<:AbstractFloat
	a, b, c = tri
    ab, bc, ca = edges(tri)
    pl = Plane(tri)
    if !parallel(l, pl)
        p = inter(l, pl)
        return p in tri ? p : INF3
    elseif !(l in Plane(tri))
        return INF3
    else
        return minimum(inter(l, ab), inter(l, bc), inter(l, ca))
    end
end

"""Returns intersection of ray and mesh"""
function inter(l::AbstractLine3, mesh::TriangleMesh{3})::Point3 where T<:AbstractFloat
    p = l.start_point
    inter_point = INF3
    min_dist = Inf
    for tri in mesh
        cand_point = inter(l, tri)
        cand_dist = norm(cand_point - p)
        if cand_dist < min_dist
            inter_point, min_dist = cand_point, cand_dist
        end
    end
    inter_point
end