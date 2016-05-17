
VO_KeyBoardModel = class(function(self)
	self.m_nKeyCode = 0
end)

function VO_KeyBoardModel.setKeyCode(self, keyCode)
	self.m_nKeyCode = keyCode
end

function VO_KeyBoardModel.getKeyCode(self)
	return self.m_nKeyCode
end


VO_SkillCDModel = class(function(self, nSkillId, fCooldown)
	self.m_nSkillId = nSkillId
	self.m_fCooldown = fCooldown
end)

function VO_SkillCDModel.getSkillId(self)
	return self.m_nSkillId
end

function VO_SkillCDModel.getCooldown(self)
	return self.m_fCooldown
end