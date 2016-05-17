
require "common/AcknowledgementMessage"

-- [1022]货币 -- 角色 

ACK_ROLE_CURRENCY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_CURRENCY
	self:init()
end)

function ACK_ROLE_CURRENCY.deserialize(self, reader)
	self.gold = reader:readInt32Unsigned() -- {银元}
	self.rmb = reader:readInt32Unsigned() -- {金元}
	self.bind_rmb = reader:readInt32Unsigned() -- {绑定金元}
end

-- {银元}
function ACK_ROLE_CURRENCY.getGold(self)
	return self.gold
end

-- {金元}
function ACK_ROLE_CURRENCY.getRmb(self)
	return self.rmb
end

-- {绑定金元}
function ACK_ROLE_CURRENCY.getBindRmb(self)
	return self.bind_rmb
end
