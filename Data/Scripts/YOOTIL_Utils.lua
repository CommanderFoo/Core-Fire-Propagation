--[[
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

local Utils = {}

local random = math.random
local randomseed = math.randomseed

-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console

function Utils.dump(node)
	local cache, stack, output = {}, {}, {}
	local depth = 1
	local output_str = "{\n"

	while(true) do
		local size = 0

		for k, v in pairs(node) do
			size = size + 1
		end

		local cur_index = 1
		
		for k, v in pairs(node) do
			if(cache[node] == nil) or (cur_index >= cache[node]) then
				if(string.find(output_str,"}",output_str:len())) then
					output_str = output_str .. ",\n"
				elseif not (string.find(output_str,"\n",output_str:len())) then
					output_str = output_str .. "\n"
				end

				table.insert(output,output_str)
				output_str = ""

				local key

				if (type(k) == "number" or type(k) == "boolean") then
					key = "["..tostring(k).."]"
				else
					key = "['"..tostring(k).."']"
				end

				if (type(v) == "number" or type(v) == "boolean") then
					output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
				elseif (type(v) == "table") then
					output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
					
					table.insert(stack,node)
					table.insert(stack,v)
					cache[node] = cur_index+1
					break
				else
					output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
				end

				if (cur_index == size) then
					output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
				else
					output_str = output_str .. ","
				end
			else
				-- close the table
				if (cur_index == size) then
					output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
				end
			end

			cur_index = cur_index + 1
		end

		if (size == 0) then
			output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
		end

		if (#stack > 0) then
			node = stack[#stack]
			stack[#stack] = nil
			depth = cache[node] == nil and depth + 1 or depth - 1
		else
			break
		end
	end

	table.insert(output,output_str)
	output_str = table.concat(output)

	print(output_str)
end

Utils.Queue = {}

function Utils.Queue.push(self, item)
	table.insert(self.list, item)
end

function Utils.Queue.pop(self)
	return table.remove(self.list, 1)
end

function Utils.Queue.front(self)
	return self.list[1]
end

function Utils.Queue.is_empty(self)
	return #self.list == 0
end

function Utils.Queue.length(self)
	return #self.list
end

function Utils.Queue.new()
	return setmetatable({list = {}}, {__index = Utils.Queue})
end

function Utils.number_format(i)
	return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function Utils.concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + i] = t2[i]
	end
	
    return t1
end

function Utils.truncate(str, len, post_str)
	local the_str = str
	local p_str = post_str or ""

	if(#str > len) then
		the_str = the_str:sub(1, len) .. p_str
	end

	return the_str
end

function Utils.uuid()
	randomseed(os.time())

	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
        
		return string.format("%x", v)
	end)
end

function Utils.first_to_upper(str)
    return (str:gsub("^%l", string.upper))
end

return Utils