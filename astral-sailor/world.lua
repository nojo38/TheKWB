world = class:new()

function world:init()

   love.physics.setMeter(1) --the height of a meter our worlds will be 1px
   self.world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0

end