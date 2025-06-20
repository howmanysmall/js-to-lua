-- ROBLOX upstream: https://github.com/howmanysmall/js-to-lua/blob/v0.0.7-25-g5ce4081/test-input.js
local exports = {}
-- Test JavaScript file
local greeting = "Hello"
local name = "World"
local function sayHello()
	return ("%s, %s!"):format(tostring(greeting), tostring(name))
end
exports.sayHello = sayHello
return exports
