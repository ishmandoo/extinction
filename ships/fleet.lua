local geom = require("geometry")
require("ships.bombShip")
require("ships.beamShip")

local fleet = {}



fleet.ships = {
    createBombShip({ x = 300, y = 80 }, { x = 100, y = 0 }),
    createBeamShip({ x = 200, y = 280 }, { x = -10, y = -100 })
}


local SHIP_RADIUS = 5
local DEAD_COLOR = { .2, .2, .2 }

local draggingShip
local draggingEdgeStartShip
local draggingEdgeEnd

local function isInShip(pos)
    for i, ship in ipairs(fleet.ships) do
        if geom.dist(pos, ship.pos) <= SHIP_RADIUS then
            return ship
        end
    end
end


local function updateGravityObject(dt, obj, planets)
    obj.vel = obj.vel or { x = 0, y = 0 }
    obj.pos.x = obj.pos.x + obj.vel.x * dt
    obj.pos.y = obj.pos.y + obj.vel.y * dt

    for j, planet in ipairs(planets) do
        local dx = planet.pos.x - obj.pos.x
        local dy = planet.pos.y - obj.pos.y
        local dist = math.sqrt(dx * dx + dy * dy)


        if dist < planet.radius then
            obj.alive = false
            if obj.explodeRadius then
                explode(obj.pos, obj.explodeRadius)
            end
        end

        local acc = 1000000 / (dist * dist)

        obj.vel.x = obj.vel.x + acc * dx / dist * dt
        obj.vel.y = obj.vel.y + acc * dy / dist * dt
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if state == State.SETUP then
        local ship = isInShip({ x = x, y = y })
        if button == 1 then
            if ship then
                draggingShip = ship
            else
                local newShip = { type = ShipType.BOMB, pos = { x = x, y = y }, vel = nil, color = { 255, 0, 255 }, alive = true, beamTarget = nil, }
                table.insert(fleet.ships, newShip)
            end
        elseif button == 2 then
            if ship then
                draggingEdgeStartShip = ship
                ship.vel = nil
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        draggingShip = nil
    elseif button == 2 then
        if draggingEdgeStartShip then
            draggingEdgeStartShip.vel = geom.sub({ x = x, y = y }, draggingEdgeStartShip.pos)
            draggingEdgeStartShip = nil
            draggingEdgeEnd = nil
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if draggingShip then
        draggingShip.pos = { x = x, y = y }
    end
    if draggingEdgeStartShip then
        draggingEdgeEnd = { x = x, y = y }
    end
end

function fleet.action(key)
    if state == State.RUNNING then
        if key == "space" then
            for i, ship in ipairs(fleet.ships) do
                if ship.type == ShipType.BOMB then
                    table.insert(bombs, createBomb(ship))
                end
            end
        end
    end
end

fleet.draw = function(planets)
    for i, ship in ipairs(fleet.ships) do
        if ship.beamTarget then
            love.graphics.setColor(0.9, 0.95, 1.0)
            love.graphics.setLineWidth(10)
            love.graphics.line(ship.pos.x, ship.pos.y, planets[ship.beamTarget].pos.x, planets[ship.beamTarget].pos.y)
        end

        if state == State.SETUP and ship.vel then
            love.graphics.setColor(1., 1., 1.)
            love.graphics.setLineWidth(1)
            love.graphics.line(ship.pos.x, ship.pos.y, ship.pos.x + ship.vel.x, ship.pos.y + ship.vel.y)
        end

        love.graphics.setColor(ship.alive and ship.color or DEAD_COLOR)
        love.graphics.circle("fill", ship.pos.x, ship.pos.y, 5)

        if draggingEdgeStartShip and draggingEdgeEnd then
            love.graphics.line(draggingEdgeStartShip.pos.x, draggingEdgeStartShip.pos.y, draggingEdgeEnd.x,
                draggingEdgeEnd.y)
        end
    end

    drawBombs()
end

fleet.update = function(dt, planets)
    draggingEdgeEnd, draggingEdgeStartShip, draggingEdgeEnd = nil, nil, nil
    for i, ship in ipairs(fleet.ships) do
        if ship.alive then
            updateGravityObject(dt, ship, planets)
            if ship.type == ShipType.BEAM then
                updateBeam(ship, planets)
                if ship.beamTarget then
                    beam(ship.pos, planets[ship.beamTarget].pos, 10)
                end
            end
        end
    end

    for i, bomb in ipairs(bombs) do
        if bomb.alive then
            updateGravityObject(dt, bomb, planets)
        end
    end
end


return fleet
