local weapon = script:FindAncestorByType("Weapon")

weapon.targetImpactedEvent:Connect(function(weapon, impact_data)
	local target = impact_data.targetObject

	if(Object.IsValid(target) and target.name == "Fire Propagation Collider") then
		if(not target:GetCustomProperty("on_fire")) then
			target:SetNetworkedCustomProperty("on_fire", true)
		end
	end
end)