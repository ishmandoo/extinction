local planets = {
    { radius = 100, pos = { x = 300, y = 200 }, color = { 255, 0, 0 }, creatures = { 0, 10 } },
    { radius = 50,  pos = { x = 600, y = 200 }, color = { 0, 255, 0 }, creatures = {} },
}

local fleet = {
    { pos = { x = 300, y = 80 }, vel = { x = 100, y = 0 }, dir = 0, color = { 0, 0, 255 } },
}

local bullets = {
}

local text = " "

function love.keypressed( key )
	fire()
	-- if key == "space" then
		-- for i=0,5 do
			-- table.insert(
				-- fleet, { pos = { x = 0 + i*10, y = 85 + i * 10}, vel = {x = 20, y =30}, dir = 0, color = { .2, .5, .8 } }
			-- )
		-- end
	-- end
	-- if key == "a" then
		-- text = "A-0k!"
	-- end
end

function love.keyreleased( key )
	text = ""
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
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()

	-- bang!
	for i, ship in ipairs(fleet) do
		love.graphics.print( text, ship.pos.x + 25, ship.pos.y + 40 )
	end

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
	
	for i, bullet in ipairs(bullets) do
		love.graphics.setColor(bullet.color)
		love.graphics.circle("fill", bullet.pos.x, bullet.pos.y, 2)
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
