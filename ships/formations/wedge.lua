local geom = require("geometry")

local formation = {}

local formationVel = { x = 0, y = -50 }
local formationScale = 20
local formationPos = { x = 150, y = 500 }


formation.bombShips = {}
formation.beamShips = {}

-- add bombers. make it a loop 
table.insert(
    formation.bombShips,
    {
        pos = geom.add( formationPos, { x = 0, y = 0 } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.bombShips,
    {
        pos = geom.add( formationPos, { x = -formationScale, y = formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.bombShips,
    {
        pos = geom.add( formationPos, { x = formationScale, y = formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)


-- add beamers. make it a loop over predefined positions / velocities
table.insert(
    formation.beamShips,
    {
        pos = geom.add( formationPos, { x = 0,  y = -2*formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.beamShips,
    {
        pos = geom.add( formationPos, { x = formationScale,  y = -formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.beamShips,
    {
        pos = geom.add( formationPos, { x = 2*formationScale,  y = 0*formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.beamShips,
    {
        pos = geom.add( formationPos, { x = -formationScale,  y = -formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)
table.insert(
    formation.beamShips,
    {
        pos = geom.add( formationPos, { x = -2*formationScale,  y = 0*formationScale } ),
        vel = { x = formationVel.x, y = formationVel.y }
    }
)



return formation