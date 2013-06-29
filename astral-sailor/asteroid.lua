asteroid = class:new()

function asteroid:init()

   self.debug = false
   -- asteroid
   asteroidImg = love.graphics.newImage("graphics/asteroid.png")
   self.width = asteroidImg:getWidth()
   self.height = asteroidImg:getHeight()
   -- table of asteroids
   self.asteroids = {}
   self.scale = 1

   self.numAsteroids = math.random(20)

   for i=1, self.numAsteroids do
      local p = {}
      local x = math.random(8,792)
      local y = math.random(8,592)

      p.body = love.physics.newBody(world.world, x, y, "dynamic")
      p.shape = love.physics.newCircleShape(8) -- radius of 8
      p.fixture = love.physics.newFixture(p.body, p.shape, 1) --attach shape to body

      p.fixture:setRestitution(0.9) --let the ball bounce

      p.body:applyForce(math.random(-300,300),math.random(-300,300))
      p.body:applyAngularImpulse(math.random(-100,100))

      table.insert(self.asteroids, p)
   end



end

function asteroid:draw()


   for i=1,#self.asteroids do
      local rot = self.asteroids[i].body:getAngle()
      local rad = self.asteroids[i].shape:getRadius()
      local x = self.asteroids[i].body:getX()
      local y = self.asteroids[i].body:getY()

      love.graphics.draw(asteroidImg,
			 x, y,
			 rot,
			 self.scale, self.scale,
			 self.width/2, self.height/2)
  
      if self.debug then 
	 local x2 = x + (math.cos (rot) * rad)
	 local y2 = y + (math.sin (rot) * rad)
	 love.graphics.circle("fill", x, y, rad)
	 love.graphics.setColor(0, 0, 0)
	 love.graphics.line(x, y, x2, y2)
      end

   end

end

function asteroid:update(dt)

   if self.debug then
      print ("# asteroids: " .. #self.asteroids)
--      print ("asteroid x,y: " .. p.body:getX() .. " " ..
--	     p.body:getY())
--      print ("asteroid rot: " .. math.rad(.body:getAngle()) % 360)

   end

end
