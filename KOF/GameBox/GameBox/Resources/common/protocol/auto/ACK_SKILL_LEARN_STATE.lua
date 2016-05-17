
require "common/AcknowledgementMessage"

-- (手动) -- [6560]学习技能成功 -- 技能系统 

ACK_SKILL_LEARN_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_LEARN_STATE
	self:init()
end)

function ACK_SKILL_LEARN_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1:成功|0:失败}
end

-- {1:成功|0:失败}
function ACK_SKILL_LEARN_STATE.getState(self)
	return self.state
end
