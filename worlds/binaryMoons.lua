local geom = require("geometry")


local ss = {}

local DEAD_COLOR = { 50, 50, 50 }

ss.planets = {
    { radius = 40, pos = { x = 400, y = 400 }, color = { 255, 0, 0 }, creatures = { 0, 25, 77 }, period = 2, center = { x = 400, y = 200 },
        moons = {
            { radius = 20, pos = { x = 70, y = 0 }, color = { 0.4, 0.3, 0.5 }, period = .7 }
        }
    }
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
        for j, moon in ipairs(planet.moons) do
            local mposp = geom.rotate_vec2d( moon.pos.x, moon.pos.y, dt/moon.period )
            moon.pos.x = mposp.x
            moon.pos.y = mposp.y
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
        for j, moon in ipairs(planet.moons) do
            love.graphics.setColor(moon.color)
            love.graphics.circle("fill", moon.pos.x + planet.pos.x, moon.pos.y+planet.pos.y, moon.radius)
        end
    end
    for i, creature in ipairs(ss.creatures) do
        love.graphics.setColor(creature.alive and creature.color or DEAD_COLOR)
        love.graphics.circle("fill", creature.pos.x, creature.pos.y, 5)
    end
end


return ss
