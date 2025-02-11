local geom = require("geometry")
require("ships/ship")

bombs = {
}

function createBombShip(pos, vel)
    local ship = createShip(pos, vel)
    ship.type = ShipType.BOMB
    ship.color = { 255, 0, 255 }
    return ship
end

function createBomb(ship)
    return { pos = geom.mult(ship.pos, 1.0), vel = geom.mult(ship.vel, 0.2), alive = true, explodeRadius = 80 }
end

function drawBombs()
    for i, bomb in ipairs(bombs) do
        if bomb.alive then
            love.graphics.setColor(255, 255, 0)
            love.graphics.circle("fill", bomb.pos.x, bomb.pos.y, 2)
        end
    end
end
