local geom = require("geometry")
local fleet = require("fleet")
local ss = require("worlds/solarSystem")

STATE_SETUP = "setup"
STATE_RUNNING = "running"
state = STATE_SETUP

function love.conf(t)
    t.console = true
end

local bullets = {
}

local text = " "

function love.keyreleased( key )
	
end
		

function fire()
		for i, ship in ipairs(fleet) do
			for j=0,4 do
				table.insert(
					bullets,
					{ pos = {x = ship.pos.x, y = ship.pos.y}, vel = { x = 2*ship.vel.x, y = 2*ship.vel.y}, dir = 0, color = {0.5, 0.6, 0.9} }
				)
			end
			text = "Bang!"
		end
end


function love.load()
    love.graphics.setBackgroundColor(0.01, 0.01, .05)
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
	if key == "p" then
		-- pause
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
	
	for i, bullet in ipairs(bullets) do
        bullet.pos.x = bullet.pos.x + bullet.vel.x * dt
        bullet.pos.y = bullet.pos.y + bullet.vel.y * dt

        for j, planet in ipairs(planets) do
            local dx = planet.pos.x - bullet.pos.x
            local dy = planet.pos.y - bullet.pos.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local acc = 1000000 / (dist * dist)

            bullet.vel.x = bullet.vel.x + acc * dx / dist * dt
            bullet.vel.y = bullet.vel.y + acc * dy / dist * dt
        end
    end
end
