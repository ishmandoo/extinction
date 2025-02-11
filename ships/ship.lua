ShipType = { BEAM = "beam", BOMB = "bomb" }

function createShip(pos, vel)
    return { pos = pos, vel = vel, alive = true, explodeRadius = 100 }
end
