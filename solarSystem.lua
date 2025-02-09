local ss = {}

local DEAD_COLOR = { 50, 50, 50 }

ss.planets = {
    { radius = 100, pos = { x = 300, y = 200 }, color = { 255, 0, 0 }, creatures = { 0, 10 } },
    { radius = 50,  pos = { x = 600, y = 200 }, color = { 0, 255, 0 }, creatures = {} },
}

ss.creatures = {}


for i, planet in ipairs(ss.planets) do
    for j, angle in ipairs(planet.creatures) do
        local x = planet.pos.x + planet.radius * math.cos(angle)
        local y = planet.pos.y + planet.radius * math.sin(angle)

        table.insert(ss.creatures, { planet = i, pos = { x = x, y = y }, color = { 255, 255, 0 }, alive = true, })
    end
end

ss.draw = function()
    for i, planet in ipairs(ss.planets) do
        love.graphics.setColor(planet.color)
        love.graphics.circle("fill", planet.pos.x, planet.pos.y, planet.radius)
    end


    for i, creature in ipairs(ss.creatures) do
        love.graphics.setColor(creature.alive and creature.color or DEAD_COLOR)
        love.graphics.circle("fill", creature.pos.x, creature.pos.y, 5)
    end
end


return ss
