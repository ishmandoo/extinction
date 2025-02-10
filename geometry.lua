local geom = {}

function geom.dist2(pos_a, pos_b)
    return (pos_b.x - pos_a.x) ^ 2 + (pos_b.y - pos_a.y) ^ 2
end

function geom.dist(pos_a, pos_b)
    return math.sqrt(geom.dist2(pos_a, pos_b))
end

function geom.add(a, b)
    return { x = a.x + b.x, y = a.y + b.y }
end

function geom.sub(a, b)
    return { x = a.x - b.x, y = a.y - b.y }
end

function geom.mult(a, k)
    return { x = a.x * k, y = a.y * k }
end

function geom.tdist(a, b)
    return geom.dist(a.pos, b.pos)
end

function geom.dot(a, b)
    return a.x * b.x + a.y * b.y
end

function geom.distToLine(line_start, line_end, pos)
    local line_vec = { x = line_end.x - line_start.x, y = line_end.y - line_start.y }
    local pos_vec = { x = pos.x - line_start.x, y = pos.y - line_start.y }

    -- Project point onto line, clamping to segment
    local t = math.max(0, math.min(1, geom.dot(pos_vec, line_vec) / geom.dist2(line_start, line_end)))
    local projection = { x = line_start.x + t * line_vec.x, y = line_start.y + t * line_vec.y }

    -- Distance from projected point to pos
    local dist_vec = { x = pos.x - projection.x, y = pos.y - projection.y }
    return math.sqrt(geom.dist2(dist_vec, { x = 0, y = 0 }))
end

return geom
