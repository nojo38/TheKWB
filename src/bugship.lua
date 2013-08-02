-- simple example class for initializing, updating, drawing, etc., for the bugship
-- ... with lots of comments
-- ... and now physics!
-- ~m4b

-- TODO:
-- 1) remove old non-physics detritus
-- 2) make static physics bodies for parts of ship not accounted for (but only for final version of an art model, otherwise waste of time)

bugship = class:new()

require "laser"

function bugship:init(x,y)

   self.debug = false

   self.imageList = {"bug-ship", 
   		     "bug-ship-afterburn",
		     "bug-ship-forwardburn",
		     "bug-ship-starboardburn",
		     "bug-ship-portburn"}
   self.imageTable = {}
   self.imageTableData = {}

   -- 1 idle, 2 afterburn, 3 forwardburn, 4 starboard, 5 port
   -- we build up set of images for this shit using a for loop
   -- not _super_ necessary, but good habit to get into
   for i = 1,#self.imageList do -- # operator gives length (num elements) of table
      self.imageTable[i] = love.graphics.newImage ("graphics/" .. self.imageList[i] .. ".png")
      self.imageTableData[i] = love.image.newImageData ("graphics/" .. self.imageList[i] .. ".png")
   end

   -- image data table
   for i = 1, #self.imageTable do
      local dimx = self.imageTableData[i]:getWidth()
      local dimy = self.imageTableData[i]:getHeight()
      if self.debug then print ("bugship image " .. i .. " is:" .. dimx .. "x" .. dimy) end
   end
   
   -- used for simple timer
   self.elapsed = 0
   -- change to make bigger ship
   -- default 32x32 pixels
   self.scale = 2 -- need to figure out why this doesn't need to be accounted for in the getWidth, etc., cases
   self.width = self.imageTable[1]:getWidth() -- since all ships have same dim, we'll use first entry in table
   self.height = self.imageTable[1]:getHeight()
 
   self.x = x
   self.y = y

-- ====== PHYSICS ======

   self.bugship = {} 
   self.bugship.body = love.physics.newBody(world.world, world.width/2, world.height/2, "dynamic")
   -- still unsure why scaling not seeming to take into account some things...
   -- we're building a triangle, facing up
   -- a tapering rectangle would fit the object better, change to that soon
   local x1 = 0
   local y1 = - ((self.height) / 2) -- because pointing "north" is reverse for love coords
   local x2 = - (( self.width) / 2)
   local y2 = (( self.height) / 2)
   local x3 = ( self.width) / 2
   local y3 = (( self.height) / 2)
   self.bugship.shape = love.physics.newPolygonShape(x1,y1,x2,y2,x3,y3) --- must be convex!
   self.bugship.fixture = love.physics.newFixture(self.bugship.body, self.bugship.shape, 4)

   self.bugship.fixture:setRestitution(0.3) -- ship is not very bouncy
   self.bugship.fixture:setUserData("bugship")
   self.bugship.body:setFixedRotation(true) -- we need this to behave in the "natural" (unrealistic) manner; hackish, however

-- =====================

-- REMOVE ALL FOR PHYSICS
   self.speed = 100

   self.rot = 0.0 -- converted to radians
   self.rotSpeed = 2
   
   -- are we idle or burning engines, etc.?
   -- 1-5, same as image index
   self.state = 1

end

function bugship:movement(dt)

   -- assume we're idle
   self.state = 1

   if love.keyboard.isDown("right") or love.keyboard.isDown ("d") then
      -- starboard burn
      self.state = 4
      -- this is for more "natural" but unrealistic rotation we all know and love; i.e., no angular velocity, so easier to handle
      local rot = self.bugship.body:getAngle()
      self.bugship.body:setAngle(rot + (self.rotSpeed * dt))

   elseif love.keyboard.isDown("left") or love.keyboard.isDown("a")then
      -- port burn
      self.state = 5
      local rot = self.bugship.body:getAngle()
      self.bugship.body:setAngle(rot - (self.rotSpeed * dt))

   end

   if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      -- bow burn
      self.state = 3
      local rot = self.bugship.body:getAngle()
      local xrotfactor = math.sin(rot)
      local yrotfactor = math.cos(rot)
      self.bugship.body:applyForce(-self.speed * xrotfactor,self.speed * yrotfactor)

   elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      -- stern burn
      self.state = 2
      local rot = self.bugship.body:getAngle()
      local xrotfactor = math.sin(rot)
      local yrotfactor = math.cos(rot)
      self.bugship.body:applyForce(self.speed * xrotfactor,-self.speed * yrotfactor)
      -- we switch signs for afterburner
   end

   if self.state == 3 or self.state == 2 then
      -- no brownian motion; need to setX, etc.
--      self.x = self.x + math.random(-0.5,0.5)
--      self.y = self.y + math.random(-0.5,0.5)
   end

end

function bugship:getImg()
   -- doesn't need to be a function but good to write interfaces
   -- the state, 1-5, gives the image; and since we've got an array of images
   -- the appropriate image to return is as simple as the following:
   return self.imageTable[self.state]
end

-- debug stats
function bugship:report()
   if self.debug then
      print ("angular damping: " .. self.bugship.body:getAngularDamping())
      print ("linear damping: " .. self.bugship.body:getLinearDamping())
      print ("time: " .. self.elapsed)
      print ("state: " .. self.state)
      print ("x: " .. self.x)
      print ("y: " .. self.y)
      local dx,dy = self.bugship.body:getLinearVelocity()
      print ("velocity: " .. dx .. "," .. dy)
      print ("speed: " .. self.speed)
      print ("rotation: " .. math.deg(self.rot))
      print ("rot speed: " .. self.rotSpeed)
   end
end

function love.keypressed(key)

      if key == "f" or key == " " then
	 laser.firing = true
	 local x = bugship.bugship.body:getX()
	 local y = bugship.bugship.body:getY()
	 local rot = bugship.bugship.body:getAngle()
	 laser:init(x, y, rot)
	 laser:report()
      end

end


function bugship:draw()

   self.elapsed = self.elapsed + love.timer.getDelta()

   local img = self:getImg()
   self.rot = self.bugship.body:getAngle()
   self.x = self.bugship.body:getX()
   self.y = self.bugship.body:getY()

   love.graphics.draw(img, -- what image we draw
      self.x, self.y, -- where
      self.rot, -- rotation to apply
      self.scale, self.scale, -- x,y scale
      self.width/2, self.height/2) -- offset
   -- last two parameters allow us to rotate about center of image

   if self.debug then

      love.graphics.polygon("fill", self.bugship.body:getWorldPoints(self.bugship.shape:getPoints()))

  end

end

function bugship:update(dt)

   self:movement(dt)
   self:report()

end
