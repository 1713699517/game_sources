
require "common/AcknowledgementMessage"

-- [6580]装备技能成功 -- 技能系统 

ACK_SKILL_EQUIP_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_EQUIP_STATE
	self:init()
end)

function ACK_SKILL_EQUIP_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1:成功|0:失败 (选择)}
end

-- {1:成功|0:失败 (选择)}
function ACK_SKILL_EQUIP_STATE.getState(self)
	return self.state
end
