local geom = require("geometry")

local formation = {}

local formationVel = { x = -10, y = -40 }
local formationScale = 20
local formationPos = { x = 20, y = 500 }
local numBombers = 3
local numBeamers = 7

formation.bombShips = {}
formation.beamShips = {}

for bomberno=0,numBombers do
    table.insert(
        formation.bombShips,
        {
            pos = geom.add( formationPos, { x = bomberno*formationScale, y = bomberno*formationScale } ),
            vel = { x = formationVel.x, y = formationVel.y }
        }
    )
end

for beamerno=0,numBeamers do
    table.insert(
        formation.beamShips,
        {
            pos = geom.add( formationPos, { x = beamerno*formationScale,  y = beamerno*formationScale-25 } ),
            vel = { x = formationVel.x, y = formationVel.y }
        }
    )
end

return formation