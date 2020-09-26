
modifier_broken_door = class({})

--------------------------------------------------------------------------------

function modifier_broken_door:IsHidden()
	return true
end

function modifier_broken_door:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end

