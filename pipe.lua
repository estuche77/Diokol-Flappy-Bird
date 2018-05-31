Pipe = {}

function Pipe:new(xPos, yPos, a, o)
    local pipes = {
        x = xPos,
        y = yPos,
        offset = o,
        width = 75,
        height = 426,
        altitude = a,
        textureTop = nil,
        textureBottom = nil
    }
    setmetatable(pipes, self)
    self.__index = self
    return pipes
end

function Pipe:display()
    if self.textureTop then
        image(self.textureTop, self.x, self.y, self.width, self.height)
    end
    if self.textureBottom then
        image(self.textureBottom, self.x, self.y + self.altitude, self.width, self.height)
    end
end

function Pipe:move(speed)
    self.x = self.x - speed
end

function Pipe:reset(x)
    -- Reset pipe X axis
    self.x = x
    -- Calculates a random Y axis
    self.y = self.offset * (math.random() - 0.5)
end

function Pipe:getX(x)
    return self.x
end

function Pipe:loadTopTexture(filename)
    self.textureTop = loadImage(filename)
end

function Pipe:loadBottomTexture(filename)
    self.textureBottom = loadImage(filename)
end

function Pipe:getBoundingBoxes()
    -- Creates a 2-index bounding box table for each pipe
    return {
        {x = self.x, y = self.y, width = self.width, height = self.height},
        {x = self.x, y = self.y + self.altitude, width = self.width, height = self.height}
    }
end