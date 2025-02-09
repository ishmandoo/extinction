local geom = require("geometry")

local fleet = {}

fleet.ships = {
    { pos = { x = 300, y = 80 }, vel = { x = 100, y = 0 }, dir = 0, color = { 0, 0, 255 }, alive = true, beamTarget = nil, },
}

local SHIP_RADIUS = 5
local DEAD_COLOR = { 50, 50, 50 }
local MAX_BEAM_DIST = 100

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

function love.mousepressed(x, y, button, istouch, presses)
    local ship = isInShip({ x = x, y = y })
    if button == 1 then
        if ship then
            draggingShip = ship
        else
            table.insert(fleet.ships,
                { pos = { x = x, y = y }, vel = nil, dir = 0, color = { 0, 0, 255 }, alive = true, beamTarget = nil, })
        end
    elseif button == 2 then
        if ship then
            draggingEdgeStartShip = ship
            ship.vel = nil
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

fleet.draw = function(planets)
    for i, ship in ipairs(fleet.ships) do
        if ship.beamTarget then
            love.graphics.setColor(255, 255, 255)
            love.graphics.setLineWidth(10)
            love.graphics.line(ship.pos.x, ship.pos.y, planets[ship.beamTarget].pos.x, planets[ship.beamTarget].pos.y)
        end

        if state == State.SETUP and ship.vel then
            love.graphics.setColor(255, 255, 255)
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
end

fleet.update = function(dt, planets)
    draggingEdgeEnd, draggingEdgeStartShip, draggingEdgeEnd = nil, nil, nil
    for i, ship in ipairs(fleet.ships) do
        if ship.alive then
            ship.vel = ship.vel or { x = 0, y = 0 }
            ship.pos.x = ship.pos.x + ship.vel.x * dt
            ship.pos.y = ship.pos.y + ship.vel.y * dt

            for j, planet in ipairs(planets) do
                local dx = planet.pos.x - ship.pos.x
                local dy = planet.pos.y - ship.pos.y
                local dist = math.sqrt(dx * dx + dy * dy)


                if dist < planet.radius then
                    ship.alive = false
                    explode(ship.pos, 100)
                end

                local acc = 1000000 / (dist * dist)

                ship.vel.x = ship.vel.x + acc * dx / dist * dt
                ship.vel.y = ship.vel.y + acc * dy / dist * dt
            end

            updateBeam(ship, planets)
            if ship.beamTarget then
                beam(ship.pos, planets[ship.beamTarget].pos, 10)
            end
        end
    end
end

return fleet
