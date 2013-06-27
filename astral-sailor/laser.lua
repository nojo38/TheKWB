-- to think that some well aimed shame lazers started this whole thing ... wheee
-- particle system example, and traveling laser beam for fun
-- ~m4b

-- TODO: 
--  (1) allow multiple lasers to be fired (without resetting), and draw them all
--  (2) make bounce?

laser = class:new()

systems = {}
current = 1

function laser:load()

--   laserburstimg = love.graphics.newImage("graphics/laser-burst.png")
   laserburstimg = love.graphics.newImage("graphics/twin-part.png")
   -- laser burst: set bunch of properties for it
   self.laserBurst = love.graphics.newParticleSystem(laserburstimg, 10)
   self.laserBurst:setLifetime(1)
   self.laserBurst:setSpread(math.rad(45)) -- in radians! this bug was not fun to track down
   self.laserBurst:setEmissionRate(100)
   self.laserBurst:setSpeed(100, 200)
   self.laserBurst:setGravity(0)
   self.laserBurst:setSizes(2, 1)
   self.laserBurst:setColors(255, 255, 255, 255, 58, 128, 255, 0)
--   self.laserBurst:setColors(220, 105, 20, 255, 194, 30, 18, 0) -- fire particle with part1.png
   self.laserBurst:setLifetime(0.25)
   self.laserBurst:setParticleLife(0.5)
--   self.laserBurst:setLifetime(1)
--   self.laserBurst:setParticleLife(1)
   self.laserBurst:setSpin(1)
   self.laserBurst:setSpinVariation(2,1)
   -- neat spinning effects with stuff like this
--   self.laserBurst:setRadialAcceleration(-2000)
--   self.laserBurst:setTangentialAcceleration(1000) 
   self.laserBurst:stop()
   table.insert(systems, self.laserBurst) -- unused

   -- laser beam properties
   laserbeamimg = love.graphics.newImage("graphics/laser-beam.png")
   self.elapsed = 0.0
   self.laserScale = 1 -- unused
   self.laserSpeed = 300
   self.laserDuration = 5 -- seconds
   self.laserPosition = {0.0, 0.0}
   self.laserDirection = 0.0
   self.laserVelocity = {0.0, 0.0}
   self.laserDamage = 10 -- unused

   self.firing = false
   self.debug = false
 
end

-- always remember rotations assumed to be in radians
function laser:init(x,y,rot) -- bugships x,y coords, and rotation
   self.elapsed = 0.0
   -- offset to make come out of nose of ship
   -- hardcoding is bad, should get the value, here 20, from image table
   local xoffset = 20*math.sin(rot)
   local yoffset = -(20*math.cos(rot)) -- notice the minus here
		    
   self.laserBurst:setPosition(x+xoffset,
			       y+yoffset)

   self.laserBurst:setDirection(rot - (math.rad(90)))
   self.laserBurst:start()

   self.laserPosition = {x+xoffset,y+yoffset}
   self.laserDirection = rot
   self.laserVelocity = {self.laserSpeed * math.sin(rot), 
			 -(self.laserSpeed * math.cos(rot))}

end

function laser:movement(dt)

   self.laserPosition = {(self.laserPosition[1] + (self.laserVelocity[1] * dt)), 
			 (self.laserPosition[2] + (self.laserVelocity[2] * dt))}

end

function laser:report()

   if self.debug then
      print("x,y: " .. self.laserBurst:getX() .. " " .. self.laserBurst:getY())
      print("rot: " .. self.laserBurst:getDirection())
      print("number: " .. self.laserBurst:count())
      print("spread: " .. self.laserBurst:getSpread())
      print("l x,y: " .. self.laserPosition[1] .. " " .. self.laserPosition[2])
      print("l dir: " .. math.deg(self.laserDirection))
      print("l vel: " .. self.laserVelocity[1] .. " " .. self.laserVelocity[2])
      print("ship dir: " .. bugship.rot)
   end
end

function laser:draw()
   
   if self.firing then 
      self.elapsed = self.elapsed + love.timer.getDelta()
      love.graphics.setColorMode("modulate") -- this allows color blending and fancy effects
      love.graphics.setBlendMode("additive") -- dunno what this does
      love.graphics.draw(self.laserBurst)
      if self.elapsed < self.laserDuration then
	 love.graphics.draw(laserbeamimg,
			    self.laserPosition[1], self.laserPosition[2],
			    self.laserDirection
			   )
      else
	 self.elapsed = 0.0
	 self.firing = false
      end
   end

end

function laser:update(dt)

   self.laserBurst:update(dt)
   self:movement(dt)
   self:report()

end
