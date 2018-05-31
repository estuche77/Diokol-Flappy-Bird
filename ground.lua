Ground = {}

function Ground:new(xPos, yPos, w, h)
    local ground = {
        x = xPos,
        y = yPos,
        width = w,
        height = h,
        texture = nil
    }
    setmetatable(ground, self)
    self.__index = self
    return ground
end

function Ground:display()
    rect(self.x, self.y, self.width, self.height)
    rect(self.x + self.width, self.y, self.width, self.height)
    if self.texture then
        image(self.texture, self.x, self.y, self.width, self.height)
	    image(self.texture, self.x + self.width, self.y, self.width, self.height)
    end
end

function Ground:move(speed)
    self.x = self.x - speed
    if self.x < self.width/2 - self.width then
		self.x = self.width/2
	end
end

function Ground:loadTexture(filename)
    self.texture = loadImage(filename)
end