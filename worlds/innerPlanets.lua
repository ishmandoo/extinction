local geom = require("geometry")


local ss = {}

local DEAD_COLOR = { 50, 50, 50 }

ss.planets = {
    -- sun
    { radius = 20, pos = { x = 400, y = 300 }, color = { 1, 1, 0.8}, period = 1, center = { x = 400, y = 300 }, creatures = {}},
    -- mercury
    { radius = 4, pos = {x = 400, y = 425}, color = {0.7, 0.7, 0.8}, period = 5, center = { x = 400, y = 300 }, creatures = {}},
    -- venus
    { radius = 8, pos = {x = 550, y = 400}, color = {0.9, 0.5, 1}, period = 8, center = {x = 400, y = 300}, creatures = {}},
    --earf
    { radius = 10, pos = { x = 620, y = 450 }, color = { 0.6, 0.8, 1. }, creatures = {}, period = 10, center = { x = 400, y = 300 },
        moons = {
            { radius = 4, pos = { x = 30, y = 0 }, color = { 0.6, 0.5, 0.7 }, period = 1, creatures = {}}
        }
    },
    --margs and brats
    { radius = 6, pos = { x = 700, y = 200 }, color = { 1., 0.8, 0.6 }, creatures = {}, period = 20, center = { x = 400, y = 300 },
        moons = {
            { radius = 2, pos = { x = 10, y = 0 }, color = { 0.7, 0.5, 0.3 }, period = 0.5, creatures = {}},
            { radius = 1, pos = { x = 5, y = 0 }, color = { 0.8, 0.6, 0.4 }, period = 0.25, creatures = {}}
        }
    },
}


ss.creatures = {}


for i, planet in ipairs(ss.planets) do
    for j, angle in ipairs(planet.creatures) do
        local angle_deg = angle * math.pi / 180
        local x = planet.pos.x + planet.radius * math.cos(angle_deg)
        local y = planet.pos.y + planet.radius * math.sin(angle_deg)

        table.insert(ss.creatures, { planet = i, pos = { x = x, y = y }, color = { 255, 255, 0 }, alive = true, })
    end
end

ss.update = function(dt)
    for i, planet in ipairs(ss.planets) do
        -- rotate moons in orbit
        if planet.moons then
            for j, moon in ipairs(planet.moons) do
                local mposp = geom.rotate_vec2d( moon.pos.x, moon.pos.y, dt/moon.period )
                moon.pos.x = mposp.x
                moon.pos.y = mposp.y
            end
        end
        -- rotate planet around orbit
        local posp = geom.sub(planet.pos, planet.center)
        posp = geom.rotate_vec2d( posp.x, posp.y, dt/planet.period )
        posp = geom.add(posp, planet.center)
        planet.pos.x = posp.x
        planet.pos.y = posp.y
    end
end

ss.draw = function()
    for i, planet in ipairs(ss.planets) do
        love.graphics.setColor(planet.color)
        love.graphics.circle("fill", planet.pos.x, planet.pos.y, planet.radius)
        if planet.moons then
            for j, moon in ipairs(planet.moons) do
                love.graphics.setColor(moon.color)
                love.graphics.circle("fill", moon.pos.x + planet.pos.x, moon.pos.y+planet.pos.y, moon.radius)
            end
        end
    end
    for i, creature in ipairs(ss.creatures) do
        love.graphics.setColor(creature.alive and creature.color or DEAD_COLOR)
        love.graphics.circle("fill", creature.pos.x, creature.pos.y, 5)
    end
end


return ss
