
require "common/AcknowledgementMessage"

-- (手动) -- [1370]通知加buff -- 角色 

ACK_ROLE_BUFF = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_BUFF
	self:init()
end)

function ACK_ROLE_BUFF.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {buff的id}
	self.state = reader:readInt8Unsigned() -- {1:已经领取|0：可以领取}
end

-- {buff的id}
function ACK_ROLE_BUFF.getId(self)
	return self.id
end

-- {1:已经领取|0：可以领取}
function ACK_ROLE_BUFF.getState(self)
	return self.state
end
