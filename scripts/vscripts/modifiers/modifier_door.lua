
modifier_door = class({})

--------------------------------------------------------------------------------

function modifier_door:IsHidden()
	return true
end

function modifier_door:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end

