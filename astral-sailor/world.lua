world = class:new()

function world:init()

   love.physics.setMeter(64) -- the height of a meter our worlds will be 64px
   self.world = love.physics.newWorld(0, 0, true) -- create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
   self.dimx = 800 -- hardcoded, remove
   self.dimy = 600 -- hardcoded, remove

   --world boundaries

  self.right = {}
  self.right.body = love.physics.newBody(self.world, self.dimx-1/2, self.dimy/2, "static")
  self.right.shape = love.physics.newRectangleShape(0, 0, 1, self.dimy)
  self.right.fixture = love.physics.newFixture(self.right.body, self.right.shape)

  self.left = {}
  self.left.body = love.physics.newBody(self.world, -1/2, self.dimy/2, "static")
  self.left.shape = love.physics.newRectangleShape(0, 0, 10, self.dimy)
  self.left.fixture = love.physics.newFixture(self.left.body, self.left.shape)

  self.top = {}
  self.top.body = love.physics.newBody(self.world, self.dimx/2, self.dimy-1/2, "static")
  self.top.shape = love.physics.newRectangleShape(0, 0, self.dimx, 10)
  self.top.fixture = love.physics.newFixture(self.top.body, self.top.shape)

  self.bot = {}
  self.bot.body = love.physics.newBody(self.world, self.dimx/2, -1/2, "static")
  self.bot.shape = love.physics.newRectangleShape(0, 0, self.dimx, 10)
  self.bot.fixture = love.physics.newFixture(self.bot.body, self.bot.shape)

  self.debug = true

end

function world:draw()

   if self.debug then
      love.graphics.setColor(50, 50, 50) -- set the drawing color to grey for the walls
      love.graphics.polygon("fill", self.left.body:getWorldPoints(self.left.shape:getPoints()))
      love.graphics.polygon("fill", self.right.body:getWorldPoints(self.right.shape:getPoints()))
      love.graphics.polygon("fill", self.top.body:getWorldPoints(self.top.shape:getPoints()))
      love.graphics.polygon("fill", self.bot.body:getWorldPoints(self.bot.shape:getPoints()))
      print ("left xy: " .. (self.left.body:getX()) .. " " .. (self.left.body:getY()))
      print ("right xy: " .. (self.right.body:getX()) .. " " .. (self.right.body:getY()))
      print ("top xy: " .. (self.top.body:getX()) .. " " .. (self.top.body:getY()))
      print ("bot xy: " .. (self.bot.body:getX()) .. " " .. (self.bot.body:getY()))

      love.graphics.setColor(255, 255, 255)

   end

end

function world:update()



end