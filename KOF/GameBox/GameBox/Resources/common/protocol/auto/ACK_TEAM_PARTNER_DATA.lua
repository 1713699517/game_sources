
require "common/AcknowledgementMessage"

-- (手动) -- [3505]伙伴信息块 -- 组队系统 

ACK_TEAM_PARTNER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_PARTNER_DATA
	self:init()
end)

function ACK_TEAM_PARTNER_DATA.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {伙伴ID}
	self.lv = reader:readInt16Unsigned() -- {伙伴等级}
	self.state = reader:readInt8Unsigned() -- {伙伴状态(1:选择 | 0：未选择)}
end

-- {伙伴ID}
function ACK_TEAM_PARTNER_DATA.getId(self)
	return self.id
end

-- {伙伴等级}
function ACK_TEAM_PARTNER_DATA.getLv(self)
	return self.lv
end

-- {伙伴状态(1:选择 | 0：未选择)}
function ACK_TEAM_PARTNER_DATA.getState(self)
	return self.state
end
