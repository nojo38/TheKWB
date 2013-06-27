asteroid = class:new()

function asteroid:init()

   -- asteroid
   asteroidImg = love.graphics.newImage("graphics/asteroid.png")
   -- table of asteroids
   self.asteroids = {}
   -- an asteroid -- change to array later
   self.asteroids.a1 = {}
   self.asteroids.a1.body = love.physics.newBody(world.world, world.dimx/2, world.dimy/2, "dynamic") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
   self.asteroids.a1.shape = love.physics.newCircleShape(8) -- radius should be 8, but 16 working...
   self.asteroids.a1.fixture = love.physics.newFixture(self.asteroids.a1.body, self.asteroids.a1.shape, 1) --attach shape to body

  self.asteroids.a1.fixture:setRestitution(0.9) --let the ball bounce

   self.asteroids.a1.body:applyForce(200,-100)
--   self.asteroids.a1.body:applyTorque(500)
--math.random(-200,200),math.random(-200,200))

   self.debug = true

end

function asteroid:draw()

  love.graphics.draw(asteroidImg, 
		     self.asteroids.a1.body:getX(),
		     self.asteroids.a1.body:getY())
--		     self.asteroids.a1.body:getWorldPoints(self.asteroids.a1.shape:getPoints()))

end

function asteroid:update(dt)

   if self.debug then
      print ("x,y: " .. self.asteroids.a1.body:getX() .. " " ..
	     self.asteroids.a1.body:getY())
   end

end
