-- simple example class for initializing, updating, drawing, etc., for the bugship
-- ... with lots of comments
-- ~m4b

bugship = class:new()

require "laser"

function bugship:init(x,y)

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
   
   self.debug = false
   -- used for simple timer
   self.elapsed = 0
   -- change to make bigger ship
   -- default 32x32 pixels
   self.scale = 2
   self.width = self.imageTable[1]:getWidth() -- since all ships have same dim, first entry fine
   self.height = self.imageTable[1]:getHeight()
 
   self.x = x
   self.y = y
   self.velocity = {0.0,0.0} -- velocity is a 2d vector
   self.maxVelocity = 100
   self.speed = 150

   -- we should probably do rotational velocity, that could be fun too
   self.rot = 0.0 -- converted to radians
   self.rotSpeed = 75.0
   
   -- are we idle or burning engines, etc.?
   -- 1-5, same as image index
   self.state = 1
   self.bouncing = false -- are we bouncing?

end

function bugship:movement(dt)

   -- assume we're idle
   self.state = 1

   if love.keyboard.isDown("right") or love.keyboard.isDown ("d") then
      -- starboard burn
      self.state = 4
      self.rot = math.rad((math.deg(self.rot) + (self.rotSpeed * dt)) % 360)
      -- we need to modulo 360 the self.rot incrementation here
      -- otherwise its _possible_ to overflow a machine number, sorry i'm paranoid whatever

   elseif love.keyboard.isDown("left") or love.keyboard.isDown("a")then
      -- port burn
      self.state = 5
      self.rot = math.rad((math.deg(self.rot) - (self.rotSpeed * dt)) % 360)
   end

   if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      -- bow burn
      self.state = 3
      self.velocity[1] = self.velocity[1] - (self.speed * dt * math.sin(self.rot))
      self.velocity[2] = self.velocity[2] + (self.speed * dt * math.cos(self.rot))

   elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      -- stern burn
      self.state = 2
      self.velocity[1] = self.velocity[1] + (self.speed * dt * math.sin(self.rot))
      self.velocity[2] = self.velocity[2] - (self.speed * dt * math.cos(self.rot))
      -- we switch signs for afterburner
   end

   -- update location
   self.x = self.x + (self.velocity[1] * dt)
   self.y = self.y + (self.velocity[2] * dt)
   if self.state == 3 or self.state == 2 then
       -- add some brownian motion if we're thrusting
      self.x = self.x + math.random(-0.5,0.5)
      self.y = self.y + math.random(-0.5,0.5)
   end

   self:boundsCheck(self.x, self.y)


end

function bugship:getImg()
   -- doesn't need to be a function but good to write interfaces
   -- the state, 1-5, gives the image; and since we've got an array of images
   -- the appropriate image to return is as simple as the following:
   return self.imageTable[self.state]
end

function bugship:boundsCheck(x,y)

   -- make hardcoded 800, 600 world readable values world.width, etc.
   -- i.e., we need a global module which gives game state stats
   -- need to only change the sign once, have it float back after that

   -- still a bug here; if going fast enough y can switch bouncing to true
   -- then x boundaries crossed, and x not caught
   -- dumb solution: two switches, one for each boundary
   if (x <= 0 or x >= 800) and not self.bouncing then
      self.velocity[1] = -self.velocity[1]
      self.bouncing = true
   elseif
      (y <= 0 or y >= 600) and not self.bouncing then
      self.velocity[2] = -self.velocity[2]
      self.bouncing = true
   else
      self.bouncing = false
   end

end


-- debug stats
function bugship:report()
   if self.debug then
      print ("time: " .. self.elapsed)
      print ("state: " .. self.state)
      print ("x: " .. self.x)
      print ("y: " .. self.y)
      print ("velocity: " .. self.velocity[1] .. "," .. self.velocity[2])
      print ("speed: " .. self.speed)
      print ("rotation: " .. math.deg(self.rot))
      print ("rot speed: " .. self.rotSpeed)
   end
end

function love.keypressed(key)

      if key == "f" or key == " " then
	 laser.firing = true
	 laser:init(bugship.x, bugship.y, bugship.rot)
	 laser:report()
      end

end


function bugship:draw()

   self.elapsed = self.elapsed + love.timer.getDelta()

   local img = self:getImg()

   love.graphics.draw(img, -- what image we draw
      self.x, self.y, -- where
      self.rot, -- rotation to apply
      self.scale, self.scale, -- x,y scale
      self.width/2, self.height/2) -- offset
   -- last two parameters allow us to rotate about center of image

end

function bugship:update(dt)

   self:movement(dt)
   self:report()

end
