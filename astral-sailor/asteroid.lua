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
--  self.asteroids.a1.body:applyForce(-100,-100)
   self.asteroids.a1.body:applyTorque(4000)
   self.asteroids.a1.body:applyAngularImpulse(100)
--math.random(-200,200),math.random(-200,200))

   self.debug = false

end

function asteroid:draw()

   local rot = math.rad((self.asteroids.a1.body:getAngle()) % 360) -- according to doc this shouldn't be in rad
   local rad = self.asteroids.a1.shape:getRadius()
   local x = self.asteroids.a1.body:getX()
   local y = self.asteroids.a1.body:getY()

-- ASTEROID NOT BEING DRAWN CORRECTLY --- due to rotation, positive
  love.graphics.draw(asteroidImg, -- problematic asteroid not being drawn right
     -- due to: angles not correct, or boundaries not correct, etc. fix below
     x, -- maybe working, but a hack
     y, -- image being rendered needs offset because for same reason in world, the body anchors at center
     rot,
     self.scale, self.scale,
     asteroidImg:getWidth()/2, asteroidImg:getHeight()/2) -- causes wild fluctuations
  
  if self.debug then 
     local x2 = x + (math.cos (rot) * rad)
     local y2 = y + (math.sin (rot) * rad)
     love.graphics.circle("fill", x, y, rad)
     love.graphics.setColor(0, 0, 0)
     love.graphics.line(x, y, x2, y2)
  end

end

function asteroid:update(dt)

   if self.debug then
      print ("asteroid x,y: " .. self.asteroids.a1.body:getX() .. " " ..
	     self.asteroids.a1.body:getY())
      print ("asteroid rot: " .. self.asteroids.a1.body:getAngle() % 360)

   end

end
