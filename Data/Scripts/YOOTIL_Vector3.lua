--[[
https://github.com/excessive/cpml/blob/master/modules/vec3.lua

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

local _Vector3 = {}

local sqrt = math.sqrt

_Vector3.distance = function(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	local dz = a.z - b.z

	return sqrt(dx * dx + dy * dy + dz * dz)
end

_Vector3.distance_squared = function(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	local dz = a.z - b.z

	return dx * dx + dy * dy + dz * dz
end

_Vector3.scale = function(a, b)
	return Vector3.New(a.x * b, a.y * b, a.z * b)
end

_Vector3.is_zero = function(a)
	return a.x == 0 and a.y == 0 and a.z == 0
end

_Vector3.cross = function(a, b)
	return Vector3.New(
		a.y * b.z - a.z * b.y,
		a.z * b.x - a.x * b.z,
		a.x * b.y - a.y * b.x
	)
end

_Vector3.dot = function(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

_Vector3.len = function(a)
	return sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

_Vector3.normalize = function(a)
	if(Vector3.is_zero(a)) then
		return Vector3.New()
	end

	return Vector3.scale(a, 1 / Vector3.len(a))
end

_Vector3.lerp = function(a, b, s)
	return a + (b - a) * s
end

_Vector3.to_string = function(a)
	return string.format("(%+0.3f, %+0.3f, %+0.3f)", a.x, a.y, a.z)
end

return _Vector3