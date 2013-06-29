asteroid = class:new()

function asteroid:init()

   -- asteroid
   asteroidImg = love.graphics.newImage("graphics/asteroid.png")
   -- table of asteroids
   self.asteroids = {}
   -- an asteroid -- change to array later
   self.asteroids.a1 = {}
   self.asteroids.a1.body = love.physics.newBody(world.world, world.width/2, world.height/2, "dynamic") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
   self.asteroids.a1.shape = love.physics.newCircleShape(8) -- radius should be 8, but 16 working...
   self.asteroids.a1.fixture = love.physics.newFixture(self.asteroids.a1.body, self.asteroids.a1.shape, 1) --attach shape to body

  self.asteroids.a1.fixture:setRestitution(0.9) --let the ball bounce

  self.asteroids.a1.body:applyForce(math.random(-300,300),math.random(-300,300))
--  self.asteroids.a1.body:applyForce(-100,-100)
--   self.asteroids.a1.body:applyTorque(4000)
  self.asteroids.a1.body:applyAngularImpulse(100)
--math.random(-200,200),math.random(-200,200))

  self.debug = false
  self.scale = 1

end

function asteroid:draw()

   local rot = self.asteroids.a1.body:getAngle()
   local rad = self.asteroids.a1.shape:getRadius()
   local x = self.asteroids.a1.body:getX()
   local y = self.asteroids.a1.body:getY()

  love.graphics.draw(asteroidImg,
     x, y,
     rot,
     self.scale, self.scale,
     asteroidImg:getWidth()/2, asteroidImg:getHeight()/2)
  
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
