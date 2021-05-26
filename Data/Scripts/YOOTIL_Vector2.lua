--[[
https://github.com/excessive/cpml/blob/master/modules/vec2.lua

The MIT License (MIT)

Copyright (c) 2021 pixeldepth.net

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local _Vector2 = {}

local sqrt = math.sqrt
local deg = math.deg
local atan = math.atan
local acos = math.acos

_Vector2.distance = function(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y

	return sqrt(dx * dx + dy * dy)
end

_Vector2.distance_squared = function(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y

	return dx * dx + dy * dy
end

_Vector2.scale = function(a, b)
	return Vector2.New(a.x * b, a.y * b)
end

_Vector2.is_zero = function(a)
	return a.x == 0 and a.y == 0
end

_Vector2.cross = function(a, b)
	return a.x * b.y - a.y * b.x
end

_Vector2.dot = function(a, b)
	return a.x * b.x + a.y * b.y
end

_Vector2.len = function(a)
	return sqrt(a.x * a.x + a.y * a.y)
end

_Vector2.normalize = function(a)
	if(Vector2.is_zero(a)) then
		return Vector2.New()
	end

	return Vector2.scale(a, 1 / Vector2.len(a))
end

_Vector2.angle_to = function(a, b)
	if(b) then
		return deg(atan(a.y - b.y, a.x - b.x))
	end

	return deg(atan(a.y, a.x))
end

_Vector2.lerp = function(a, b, s)
	return a + (b - a) * s
end

_Vector2.to_string = function(a)
	return string.format("(%+0.3f, %+0.3f)", a.x, a.y)
end

return _Vector2