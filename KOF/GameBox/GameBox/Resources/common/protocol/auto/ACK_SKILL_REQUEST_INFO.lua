
require "common/AcknowledgementMessage"

-- (手动) -- [6600]单个技能信息显示 -- 技能系统 

ACK_SKILL_REQUEST_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_REQUEST_INFO
	self:init()
end)

function ACK_SKILL_REQUEST_INFO.deserialize(self, reader)
    print("ACK_SKILL_REQUEST_INFO.deserialize 请求单个技能信息显示 6600")
	self.gold = reader:readInt32Unsigned() -- {学习该技能所需要的银币}
	self.power = reader:readInt32Unsigned() -- {学习该技能所需要的潜能}
	self.study_state = reader:readInt8Unsigned() -- {是否可以学习}
	self.equip_state = reader:readInt8Unsigned() -- {是否可以装备}
    print(self.gold, self.power, self.study_state, self.equip_state)
end

-- {学习该技能所需要的银币}
function ACK_SKILL_REQUEST_INFO.getGold(self)
	return self.gold
end

-- {学习该技能所需要的潜能}
function ACK_SKILL_REQUEST_INFO.getPower(self)
	return self.power
end

-- {是否可以学习}
function ACK_SKILL_REQUEST_INFO.getStudyState(self)
	return self.study_state
end

-- {是否可以装备}
function ACK_SKILL_REQUEST_INFO.getEquipState(self)
	return self.equip_state
end
