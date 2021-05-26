local YOOTIL = require(script:GetCustomProperty("YOOTIL"))

local data = script:GetCustomProperty("data"):WaitForObject()
local geo = script:GetCustomProperty("geo"):WaitForObject()
local fire = script:GetCustomProperty("fire"):WaitForObject()
local smoke = script:GetCustomProperty("smoke"):WaitForObject()
local start_color = script:GetCustomProperty("start_color")
local end_color = script:GetCustomProperty("end_color")
local audio = script:GetCustomProperty("audio"):WaitForObject()
local collider = script:GetCustomProperty("collider"):WaitForObject()

local color_size_tween = nil
local vfx_tween = nil

data.networkedPropertyChangedEvent:Connect(function(_, prop)
	if(prop == "health") then
		local current_health = data:GetCustomProperty("health")

		if(current_health <= 0) then
			fire:Stop()
			smoke:Stop()
		else
			if(not fire.isPlaying) then
				fire:Play()
				smoke:Play()
				audio:Play()
			end
		end

		if(color_size_tween == nil and not data:GetCustomProperty("die_down")) then
			color_size()
		end
	elseif(prop == "die_down") then
		color_size_tween = nil

		kill_vfx()
	end
end)

function kill_vfx()
	vfx_tween = YOOTIL.Tween:new(2, { 
		
		s = smoke:GetSmartProperty("Density"), 
		f = fire:GetSmartProperty("Density"),
		a = audio.volume

	}, { 
		
		s = 0, 
		f = 0,
		a = 0

	})

	vfx_tween:on_change(function(v)
		smoke:SetSmartProperty("Density", v.s)
		fire:SetSmartProperty("Density", v.f)
		audio.volume = v.a
	end)

	vfx_tween:on_complete(function()
		vfx_tween = nil
		fire:Stop()
		smoke:Stop()
		audio:Stop()
	end)
end

function color_size()
	color_size_tween = YOOTIL.Tween:new(5, { 
		
		r = start_color.r, 
		g = start_color.g, 
		b = start_color.b

	}, { 
		
		r = end_color.r, 
		g = end_color.g, 
		b = end_color.b

	})

	color_size_tween:on_change(function(v)
		for i, c in ipairs(geo:GetChildren()) do
			c:SetColor(Color.New(v.r, v.g, v.b))

			local scale = c:GetWorldScale()

			scale.z = scale.z - 0.0008

			c:SetWorldScale(scale)
		end
	end)

	color_size_tween:on_complete(function()
		color_size_tween = nil
	end)
end

function Tick(dt)
	if(color_size_tween ~= nil) then
		color_size_tween:tween(dt)
	end

	if(vfx_tween ~= nil) then
		vfx_tween:tween(dt)
	end
end