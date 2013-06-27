function love.load()

   require "class"
   require "bugship"
   require "laser"

   -- start the bugship in the middle
   bugship:init(400,300)
   laser:load()

   bg = love.graphics.newImage("graphics/star-background.png")
   

end

function love.draw(dt)

   love.graphics.draw(bg,0,0)
   bugship:draw()
   laser:draw()

end

function love.update (dt)

   if love.keyboard.isDown("q") or love.keyboard.isDown("escape") then
      love.quit()
   end

   bugship:update(dt)
   laser:update(dt)

end

function love.quit()
   love.event.quit()
end