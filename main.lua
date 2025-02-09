local planets = {
    { radius = 100, pos = { x = 300, y = 200 }, color = { 255, 0, 0 }, creatures = { 0, 10 } },
    { radius = 50,  pos = { x = 600, y = 200 }, color = { 0, 255, 0 }, creatures = {} },
}

local fleet = {
    { pos = { x = 300, y = 80 }, vel = { x = 100, y = 0 }, dir = 0, color = { 0, 0, 255 } },
}

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    for i, planet in ipairs(planets) do
        love.graphics.setColor(planet.color)
        love.graphics.circle("fill", planet.pos.x, planet.pos.y, planet.radius)
        for j, creature in ipairs(planet.creatures) do
            love.graphics.setColor(0, 255, 0)
            love.graphics.circle("fill", planet.pos.x + planet.radius * math.cos(creature),
                planet.pos.y + planet.radius * math.sin(creature), 5)
        end
    end

    for i, ship in ipairs(fleet) do
        love.graphics.setColor(ship.color)
        love.graphics.circle("fill", ship.pos.x, ship.pos.y, 5)
    end
end

function love.update(dt)
    for i, ship in ipairs(fleet) do
        ship.pos.x = ship.pos.x + ship.vel.x * dt
        ship.pos.y = ship.pos.y + ship.vel.y * dt

        for j, planet in ipairs(planets) do
            local dx = planet.pos.x - ship.pos.x
            local dy = planet.pos.y - ship.pos.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local acc = 1000000 / (dist * dist)

            ship.vel.x = ship.vel.x + acc * dx / dist * dt
            ship.vel.y = ship.vel.y + acc * dy / dist * dt
        end
    end
end
