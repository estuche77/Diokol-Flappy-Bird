Bird = {}

function Bird:new(xPos, yPos, b)
    local bird = {
        x = xPos,
        y = yPos,
        width = 136/3,
        height = 96/3,
        bottom = b,
        gravity = -10,
        textures = {},
        hovering = 0,
        tex_id = 1,
        rotation = 2*PI
    }
    setmetatable(bird, self)
    self.__index = self
    return bird
end

function Bird:display()
    pushMatrix()
    -- Move where the bird should be drawn
    translate(self.x, self.y)
    -- Rotate it
    rotate(self.rotation)
    -- And draw it
    image(self.textures[math.floor(self.tex_id/10+1)], 0, 0, self.width, self.height)
    -- Change the wings texture after 10 iterations
    self.tex_id = self.tex_id % 29 + 1
    popMatrix()
end

function Bird:hover()
    -- Change the hovering bird based on sin function
    self.y = self.y + math.sin(self.hovering) * 0.5
    self.hovering = self.hovering + 0.1
end

function Bird:push()
    -- The bird gravity will change
    self.gravity = -10
end

function Bird:down()
    -- The y axis is changed based on the current gravity
    if self.y < self.bottom then
        self.y = self.y + self.gravity
    end

    -- While a little later from max altitude
    if self.gravity < 3 then
        -- Keep facing upwards
        self.rotation = 2*PI-PI/7
    else
        -- Then slowly rotates downwards
        self.rotation = map(self.gravity, 3, 13, 2*PI-PI/7, 2*PI + PI/2)
    end

    -- If not full gravity (13 constant)
    if self.gravity < 13 then
        -- Add gravity
        self.gravity = self.gravity + 0.5
    else
        -- If free falling then don't move wings
        self.tex_id = self.tex_id - 1
    end
end

function Bird:reset(y)
    -- Resets the bird
    self.y = y
    self.rotation = 2*PI
    self.gravity = -10
end

function Bird:getY()
    -- Returns Y for collision detection
    return self.y
end

function Bird:getX()
    -- Returns X for score count
    return self.x
end

function Bird:addTexture(filename)
    -- Adds bird textures to list
    local image = loadImage(filename)
    table.insert(self.textures, image)
end

function Bird:getBoundingBox()
    -- Creates a bounding box table
    return {x = self.x, y = self.y, width = self.width, height = self.height}
end