"""Finds closest point between query point and 3D triangle"""
function closest(p::S, tri::Triangle3)::S where {T<:AbstractFloat,S<:AbstractVector{T}}
    a, b, c = tri
    ab, ac, bc = b - a, c - a, c - b
    snom = dot(p - a, ab)
    sdenom = dot(p - b, a - b)
    tnom = dot(p - a, ac)
    tdenom = dot(p - c, a - c)
    if snom <= 0 && tnom <= 0
        return a
    end
    unom = dot(p - b, bc)
    udenom = dot(p - c, b - c)
    if sdenom <= 0 && unom <= 0
        return b
    elseif tdenom <= 0 && udenom <= 0
        return c
    end
    n = cross(b - a, c - a)
    vc = dot(n, cross(a - p, b - p))
    if vc <= 0 && snom >= 0 && sdenom >= 0
        return a + snom / (snom + sdenom) * ab
    end
    va = dot(n, cross(b - p, c - p))
    if va <= 0 && unom >= 0 && udenom >= 0
        return b + unom / (unom + udenom) * bc
    end
    vb = dot(n, cross(c - p, a - p))
    if vb <= 0 && tnom >= 0 && tdenom >= 0
        return a + tnom / (tnom + tdenom) * ac
    end
    u = va / (va + vb + vc)
    v = vb / (va + vb + vc)
    w = 1 - u - v 
    u*a + v*b + w*c
end

"""Returns closest point and distance between mesh and query point"""
function closest(p::S, mesh::TriangleMesh{3})::Tuple{S,T} where {T<:AbstractFloat,S<:AbstractVector{T}}
    closest_point = INF3
    closest_dist = Inf
    for tri in mesh
        cand_point = closest(p, tri)
        cand_dist = norm(cand_point - p)
        if cand_dist < closest_dist
            closest_point, closest_dist = cand_point, cand_dist
        end
    end
    closest_point, closest_dist
end