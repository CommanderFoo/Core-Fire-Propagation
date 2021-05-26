local data = script:GetCustomProperty("data"):WaitForObject()
local ray_obj = script:GetCustomProperty("ray_obj"):WaitForObject()

local damage_time = data:GetCustomProperty("damage_time")
local ticker = nil
local count = 0
local repeat_count = math.ceil(damage_time / .75)
local propagated = false

function tick_damage()
	if(ticker == nil) then
		ticker = Task.Spawn(function()
			local current_health = data:GetCustomProperty("health")
			local damage_per_tick = data:GetCustomProperty("damage_per_tick")

			data:SetNetworkedCustomProperty("health", math.max(0, current_health - damage_per_tick))

			if(count == repeat_count and current_health > 0) then
				data:SetNetworkedCustomProperty("die_down", true)
			end

			if(current_health <= 0) then
				ticker:Cancel()
				ticker = nil
			elseif(current_health <= 50 and not propagated) then
				propagated = true
				propagate(damage_per_tick - 1)
			end

			count = count + 1
		end)

		ticker.repeatCount = repeat_count
		ticker.repeatInterval = .75
	end
end

function propagate(damage)
	local hit = World.Raycast(ray_obj:GetWorldPosition(), ray_obj:GetWorldPosition() + (Vector3.RIGHT * 300), { ignorePlayers = true })

	if(hit ~= nil and hit.other.name == ray_obj.name) then
		local collider = hit.other:GetCustomProperty("collider"):GetObject()

		collider:SetNetworkedCustomProperty("damage_per_tick", damage)
		collider:SetNetworkedCustomProperty("on_fire", true)
	end

	local hit = World.Raycast(ray_obj:GetWorldPosition(), ray_obj:GetWorldPosition() + (-Vector3.RIGHT * 300), { ignorePlayers = true })

	if(hit ~= nil and hit.other.name == ray_obj.name) then
		local collider = hit.other:GetCustomProperty("collider"):GetObject()

		collider:SetNetworkedCustomProperty("damage_per_tick", damage)
		collider:SetNetworkedCustomProperty("on_fire", true)
	end

	local hit = World.Raycast(ray_obj:GetWorldPosition(), ray_obj:GetWorldPosition() + (Vector3.FORWARD * 300), { ignorePlayers = true })

	if(hit ~= nil and hit.other.name == ray_obj.name) then
		local collider = hit.other:GetCustomProperty("collider"):GetObject()

		collider:SetNetworkedCustomProperty("damage_per_tick", damage)
		collider:SetNetworkedCustomProperty("on_fire", true)
	end

	local hit = World.Raycast(ray_obj:GetWorldPosition(), ray_obj:GetWorldPosition() + (-Vector3.RIGHT * 300), { ignorePlayers = true })

	if(hit ~= nil and hit.other.name == ray_obj.name) then
		local collider = hit.other:GetCustomProperty("collider"):GetObject()

		collider:SetNetworkedCustomProperty("damage_per_tick", damage)
		collider:SetNetworkedCustomProperty("on_fire", true)
	end
end

data.networkedPropertyChangedEvent:Connect(function(_, prop)
	if(prop == "on_fire") then
		tick_damage()
	end
end)