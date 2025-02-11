local geom = require("geometry")

-- local ss = require("worlds/solarSystem")
-- local ss = require("worlds/innerPlanets")
local ss = require("worlds/binaryMoons")

-- change the fleet formation in ships/fleet and ships/formations
local fleet = require("ships/fleet")
-- local ss = require("worlds/solarSystem")

State = { SETUP = "setup", RUNNING = "running" }
state = State.SETUP

function love.conf(t)
    t.console = true
end

function love.load()
    love.graphics.setBackgroundColor(0.01, 0.01, .05)
end

function love.draw()
    fleet.draw(ss.planets)
    ss.draw()
end

function love.update(dt)
    if state == State.RUNNING then
        fleet.update(dt, ss.planets)
        ss.update(dt)
    end
end

function love.keypressed(key)
    if state == State.SETUP then
        if key == "space" then
            state = State.RUNNING
        end
    elseif state == State.RUNNING then
        if key == "space" then
            fleet.action(key)
        end
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
