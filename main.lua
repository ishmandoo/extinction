local geom = require("geometry")
local fleet = require("fleet")
local ss = require("solarSystem")

STATE_SETUP = "setup"
STATE_RUNNING = "running"
state = STATE_SETUP

function love.conf(t)
    t.console = true
end

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    fleet.draw(ss.planets)
    ss.draw()
end

function love.update(dt)
    if state == STATE_RUNNING then
        fleet.update(dt, ss.planets)
    end
end

function love.keypressed(key)
    if key == "space" then
        state = STATE_RUNNING
    end
end

function explode(pos, r)
    for i, creature in ipairs(ss.creatures) do
        local dx = creature.pos.x - pos.x
        local dy = creature.pos.y - pos.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if geom.dist(pos, creature.pos) < r then
            creature.alive = false
        end
    end
end

function beam(beamStart, beamEnd, r)
    for i, creature in ipairs(ss.creatures) do
        if geom.distToLine(beamStart, beamEnd, creature.pos) < r then
            creature.alive = false
        end
    end
end
