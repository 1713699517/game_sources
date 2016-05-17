
require "common/AcknowledgementMessage"

-- [6545]返回装备技能信息 -- 技能系统

ACK_SKILL_EQUIP_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_EQUIP_INFO
	self:init()
end)

function ACK_SKILL_EQUIP_INFO.deserialize(self, reader)
	--self.count = reader:readInt16Unsigned() -- {循环变量}
    
    self.equip_pos  = reader:readInt16Unsigned()        --技能装备位置
    self.skill_id   = reader:readInt32Unsigned()        --技能id (0:没装备)
    self.skill_lv   = reader:readInt16Unsigned()        --技能lv
    
    --]
	print("\n==========[6545]返回装备技能信息=====")
    
    print("pos=", self.equip_pos, "skill_id=", self.skill_id, "lv=", self.skill_lv)
    
    print("==========ACK_SKILL_EQUIP_INFO=====\n")
    --]]
        -----07.12
end

--技能装备位置
function ACK_SKILL_EQUIP_INFO.getEquipPos(self)
	return self.equip_pos
end

--技能id (0:没装备)
function ACK_SKILL_EQUIP_INFO.getSkillId(self)
	return self.skill_id
end

--技能lv
function ACK_SKILL_EQUIP_INFO.getSkillLv(self)
	return self.skill_lv
end