
require "common/AcknowledgementMessage"

-- [53220]面板返回 -- 新手特权 

ACK_PRIVILEGE_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PRIVILEGE_REPLY
	self:init()
end)

function ACK_PRIVILEGE_REPLY.deserialize(self, reader)
	self.is_open = reader:readInt8Unsigned() -- {是否开通:0为未开通，1为已开通}
	self.need_gold = reader:readInt32Unsigned() -- {开通所需要的钻石数}
	self.day = reader:readInt8Unsigned() -- {第几天}
	self.is_get = reader:readInt8Unsigned() -- {是否领取}
	self.money = reader:readInt32Unsigned() -- {美刀}
	self.gold = reader:readInt32Unsigned() -- {钻石}
end

-- {是否开通:0为未开通，1为已开通}
function ACK_PRIVILEGE_REPLY.getIsOpen(self)
	return self.is_open
end

-- {开通所需要的钻石数}
function ACK_PRIVILEGE_REPLY.getNeedGold(self)
	return self.need_gold
end

-- {第几天}
function ACK_PRIVILEGE_REPLY.getDay(self)
	return self.day
end

-- {是否领取}
function ACK_PRIVILEGE_REPLY.getIsGet(self)
	return self.is_get
end

-- {美刀}
function ACK_PRIVILEGE_REPLY.getMoney(self)
	return self.money
end

-- {钻石}
function ACK_PRIVILEGE_REPLY.getGold(self)
	return self.gold
end
