function love.load()

   require "class"
   require "bugship"
   require "laser"
   require "world"
   require "asteroid"

   -- set font for FPS
   font = love.graphics.newFont(love._vera_ttf, 10)
   love.graphics.setFont(font)
   love.graphics.setColor(200, 200, 200);

   world:init() -- initialize world
   asteroid:init()
   bugship:init(400,300) -- start the bugship in the middle
   laser:load()

   bg = love.graphics.newImage("graphics/star-background.png")   

end

function love.draw(dt)

   love.graphics.draw(bg,0,0)
   bugship:draw()
   laser:draw()
   asteroid:draw()
   world:draw() -- unused

   love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0);

end

function love.update (dt)

   if love.keyboard.isDown("q") or love.keyboard.isDown("escape") then
      love.quit()
   end

   bugship:update(dt)
   laser:update(dt)
   world.world:update(dt) -- sets world in motion
   asteroid:update(dt)

end

function love.quit()
   love.event.quit()
end