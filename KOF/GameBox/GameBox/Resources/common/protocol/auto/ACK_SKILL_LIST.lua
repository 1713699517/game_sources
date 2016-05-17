
require "common/AcknowledgementMessage"

-- [6520]技能列表数据 -- 技能系统 

ACK_SKILL_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_LIST
	self:init()
end)

function ACK_SKILL_LIST.deserialize(self, reader)
	self.power = reader:readInt32Unsigned() -- {战功}
end

-- {战功}
function ACK_SKILL_LIST.getPower(self)
	return self.power
end
