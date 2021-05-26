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

local Utils = require(script:GetCustomProperty("YOOTIL_Utils"))
local _Events = {}

_Events.queue = Utils.Queue:new()

function _Events.try_again()
	if(_Events.queue:length() > 20) then
		warn("Event queue is above 20.")
	end

	while(_Events.queue:length() > 0) do
		local data = _Events.queue:front()
        local result = data.method(table.unpack(data.args))

		if(result ~= BroadcastEventResultCode.EXCEEDED_RATE_LIMIT) then
            _Events.queue:pop()
        else
            Task.Wait(.1)
        end
	end
end

function _Events.broadcast_to_server(...)
	local result, message = Events.BroadcastToServer(table.unpack({...}))

	if(result == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT) then
		local evt_data = {
			
			method = Events.BroadcastToServer,
			args = {...}
		
		}
        
		_Events.queue:push(evt_data)
	end
end

function _Events.broadcast_to_player(...)
	local result, message = Events.BroadcastToPlayer(table.unpack({...}))

	if(result == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT) then
		local evt_data = {
			
			method = Events.BroadcastToPlayer,
			args = ...
		
		}
        
		_Events.queue:push(evt_data)
	end
end

function _Events.broadcast_to_all_players(...)
	local result, message = Events.BroadcastToAllPlayers(table.unpack({...}))

	if(result == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT) then
		local evt_data = {
			
			method = Events.BroadcastToAllPlayers,
			args = ...
		
		}
        
		_Events.queue:push(evt_data)
	end
end

function _Events.connect_for_player(evt, fn)
	return Events.ConnectForPlayer(evt, fn)
end

local task = Task.Spawn(_Events.try_again)

task.repeatCount = -1

return _Events