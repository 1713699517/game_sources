VO_SkillUpdateModel = class(function(self)
    self.m_slotIndex = -1
    self.m_skillID = 0
    self.m_lv = 0

    --6545
    self.skill_id     = 0
    self.equip_pos    = 0
    self.skill_lv     = 0

    --伙伴id
    self.partner_id   = 0

    --潜能 和金钱信息
    self.m_moneyList  = nil
end)

function VO_SkillUpdateModel.setSkillMoneyList( self, value)
    if self.m_moneyList == nil then
        self.m_moneyList = {}
    end
    self.m_moneyList = value
end
function VO_SkillUpdateModel.getSkillMoneyList( self)
    return self.m_moneyList
end

function VO_SkillUpdateModel.setSkillSlot(self, nIndex)
    self.m_slotIndex = nIndex
end
function VO_SkillUpdateModel.getSkillSlot(self)
    return self.m_slotIndex
end
function VO_SkillUpdateModel.setSkillId(self, nSkillId)
    self.m_skillID = nSkillId
end
function VO_SkillUpdateModel.getSkillId(self)
    return self.m_skillID
end
function VO_SkillUpdateModel.setSkillLevel(self, lv)
    self.m_lv = lv
end
function VO_SkillUpdateModel.getSkillLevel(self)
    return self.m_lv
end
function VO_SkillUpdateModel.setEquipId( self, nValue)
    self.skill_id = nValue
end
function VO_SkillUpdateModel.getEquipId( self)
    return self.skill_id
end

function VO_SkillUpdateModel.setEquipPos( self, nValue)
    self.equip_pos = nValue
end
function VO_SkillUpdateModel.getEquipPos( self)
    return self.equip_pos
end

function VO_SkillUpdateModel.setEquipLv( self, nValue)
    self.skill_lv = nValue
end
function VO_SkillUpdateModel.getEquipLv( self)
    return self.skill_lv
end

function VO_SkillUpdateModel.setParentid( self, value)
    self.partner_id = value
end
function VO_SkillUpdateModel.getParentid( self)
    return self.partner_id
end




--------6545
VO_Skill6545Model = class(function(self)
    --6545
    self.skill_id     = 0
    self.equip_pos    = 0
    self.skill_lv     = 0
end)

function VO_Skill6545Model.setEquipId( self, nValue)
    self.skill_id = nValue
end
function VO_Skill6545Model.getEquipId( self)
    return self.skill_id
end

function VO_Skill6545Model.setEquipPos( self, nValue)
    self.equip_pos = nValue
end
function VO_Skill6545Model.getEquipPos( self)
    return self.equip_pos
end

function VO_Skill6545Model.setEquipLv( self, nValue)
    self.skill_lv = nValue
end
function VO_Skill6545Model.getEquipLv( self)
    return self.skill_lv
end
