-- Jason Latouche
-- Emanuel Alvarado
-- Costa Rica Institute of Technology
-- Computer Science
-- June, 2018

require "bird"
require "pipe"
require "ground"

local width = 423
local height = 704
local speed = 2
local gameStates = {"new", "playing", "over"}
local state = 1
local score = 0
local scoreSwitch = false

function setup()
	-- Setting up the screen size
	size(width, height)

	-- Preparing random seed
	math.randomseed(os.time())

	-- Limits the frame rate to behave properly
	frameRate(60)

	-- CENTER for every mode
	rectMode(CENTER)
	imageMode(CENTER)
	ellipseMode(CENTER)

	-- Prepares and load font
	local f = loadFont("data/Vera.ttf", 40)
	textFont(f)

	-- Prepares background textures
	background = loadImage("textures/background.png")

	-- Ground texture
	ground = Ground:new(width/2, height-50, width, 100)
	ground:loadTexture("textures/ground.png")

	-- Preparing pipes
	pipes = {}
	table.insert(pipes, Pipe:new(0, 0, height-100, 200))
	table.insert(pipes, Pipe:new(0, 0, height-100, 200))

	-- Setting pipes positions
	resetPipes()

	-- Loading pipes textures
	for k, pipe in pairs(pipes) do
		pipe:loadTopTexture("textures/top_tube.png")
		pipe:loadBottomTexture("textures/bottom_tube.png")
	end

	-- Prepares bird data
	bird = Bird:new(width/2, height/2, height-110)
	bird:addTexture("textures/bird_down.png")
	bird:addTexture("textures/bird_mid.png")
	bird:addTexture("textures/bird_up.png")

	-- Read best score
	local lines = lines_from("data/BestScore")
	bestScore = 0
	for k,value in pairs(lines) do
		bestScore = tonumber(value)
	end
end

function draw()
	-- Draws background
	image(background, width/2, height/2, width, height)

	-- Draw pipes
	for k, pipe in pairs(pipes) do
		pipe:display()
	end

	-- Draw bird
	bird:display()

	-- Draw ground
	ground:display()

	-- Draw score
	textAlign(LEFT)
	text(score, 50, height - 50)

	-- Draw best score
	textAlign(RIGHT)
	text("Best: " .. bestScore, width - 50, height - 50)

	-- If is a new game
	if gameStates[state] == "new" then
		-- Move the ground
		ground:move(speed)
		-- Hover the bird
		bird:hover()

	-- If is gaming
	elseif gameStates[state] == "playing" then

		-- For each pipe
		for k, pipe in pairs(pipes) do
			-- Move the pipe
			pipe:move(speed)

			-- Reset pipe if it reaches the end of the screen
			if pipe:getX() < -75/2 then
				pipe:reset(width + 75/2)
			end

			-- Check for tubes pass
			if DoBoxesIntersect(bird:getBoundingBox(), pipe:getGapBoundingBox())
			and pipe:getX() < bird:getX()
			and not scoreSwitch then
				score = score + 1
				scoreSwitch = true

				print(score, bestScore)
				-- Check if it is the best scores
				if score > bestScore then
					-- Save into file
					append_to_file("data/BestScore", score .. '\n')
					bestScore = score
				end
			end

			-- The tube had been already counted
			if not DoBoxesIntersect(bird:getBoundingBox(), pipe:getGapBoundingBox())
			and pipe:getX() < bird:getX()
			and scoreSwitch then
				scoreSwitch = false
			end

			-- Check collision detection
			if DoBoxesIntersect(bird:getBoundingBox(), pipe:getBoundingBoxes()[1]) or 
			DoBoxesIntersect(bird:getBoundingBox(), pipe:getBoundingBoxes()[2]) then
				-- Game over
				state = 3
			end
		end

		-- Check for ground or sky collision
		if bird:getY() > height-110 or bird:getY() < -10 then
			-- Game over
			state = 3
		end

		-- Move the ground
		ground:move(speed)

		-- Bring gravity to the bird
		bird:down()

	elseif gameStates[state] == "over" then
		-- Bring gravity to the bird
		bird:down()
	end
end

-- Reads whenever SPACE is pressed
function keyPressed(key)
	if gameStates[state] == "new" then
		state = 2
	elseif gameStates[state] == "playing" and key == ' ' then
		bird:push()
	elseif gameStates[state] == "over" then
		state = 1
		resetPipes()
		bird:reset(height/2)
		score = 0
	end
end

function resetPipes()
	-- Reseting very far away from the end of the screen
	for k, pipe in pairs(pipes) do
		pipe:reset(width * 1.5 + (width/2 + 75/2) * k)
	end
end

-- Function based on Iain's answer from StackExchange's Game Development
-- Link: https://gamedev.stackexchange.com/questions/586/what-is-the-fastest-way-to-work-out-2d-bounding-box-intersection
function DoBoxesIntersect(a, b)
	return (math.abs(a.x - b.x) < (a.width + b.width) / 2) and
	(math.abs(a.y - b.y) < (a.height + b.height) / 2)
end

-- Functions for file writing
-- https://www.tutorialspoint.com/lua/lua_file_io.htm
function append_to_file(filename, line)
	-- Opens a file in append mode
	file = io.open(filename, "a")

	-- sets the default output file as test.lua
	io.output(file)

	-- appends a word test to the last line of the file
	io.write(line)

	-- closes the open file
	io.close(file)
end

-- Functions for file reading
-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end