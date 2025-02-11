local geom = require("geometry")
require("ships/ship")

local MAX_BEAM_DIST = 100


function createBeamShip(pos, vel)
    local ship = createShip(pos, vel)
    ship.type = ShipType.BEAM
    ship.beamTarget = nil
    ship.color = { 255, 255, 0 }
    return ship
end

function updateBeam(ship, planets)
    -- find closest planet
    local closest = nil
    local closest_dist = nil
    for j, planet in ipairs(planets) do
        local dist = geom.tdist(ship, planet) - planet.radius

        if closest_dist == nil or dist < closest_dist then
            closest = j
            closest_dist = dist
        end
    end

    -- draw line to closest
    if closest and closest_dist < MAX_BEAM_DIST then
        ship.beamTarget = closest
    else
        ship.beamTarget = nil
    end
end
