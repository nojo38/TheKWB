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

  self.asteroids.a1.body:applyForce(math.random(-100,100),-300)
--   self.asteroids.a1.body:applyTorque(2000)
--   self.asteroids.a1.body:applyAngularImpulse(100)
--math.random(-200,200),math.random(-200,200))

   self.debug = true

end

function asteroid:draw()


-- ASTEROID NOT BEING DRAWN CORRECTLY --- due to rotation, positive
  love.graphics.draw(asteroidImg, -- problematic asteroid not being drawn right
     -- due to: angles not correct, or boundaries not correct, etc. fix below
		     self.asteroids.a1.body:getX()+8, -- maybe working, but a hack
		     self.asteroids.a1.body:getY()-8, -- image being rendered needs offset because for same reason in world, the body anchors at center
		     math.rad(self.asteroids.a1.body:getAngle()) % 360) -- causes wild fluctuations
  
--		     self.asteroids.a1.body:getWorldPoints(self.asteroids.a1.shape:getPoints()))

end

function asteroid:update(dt)

   if self.debug then
      print ("asteroid x,y: " .. self.asteroids.a1.body:getX() .. " " ..
	     self.asteroids.a1.body:getY())
      print ("asteroid rot: " .. self.asteroids.a1.body:getAngle() % 360)

   end

end
