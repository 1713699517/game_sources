
require "common/AcknowledgementMessage"

-- [52260]神器强化所需要钱数返回 -- 神器 

ACK_MAGIC_EQUIP_NEED_MONEY_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_NEED_MONEY_REPLY
	self:init()
end)

function ACK_MAGIC_EQUIP_NEED_MONEY_REPLY.deserialize(self, reader)
	self.bless_rmb = reader:readInt16Unsigned() -- {祝福石钱数}
	self.protect_rmb = reader:readInt16Unsigned() -- {保护符钱数}
	self.total_rmb = reader:readInt16Unsigned() -- {总共花费}
end

-- {祝福石钱数}
function ACK_MAGIC_EQUIP_NEED_MONEY_REPLY.getBlessRmb(self)
	return self.bless_rmb
end

-- {保护符钱数}
function ACK_MAGIC_EQUIP_NEED_MONEY_REPLY.getProtectRmb(self)
	return self.protect_rmb
end

-- {总共花费}
function ACK_MAGIC_EQUIP_NEED_MONEY_REPLY.getTotalRmb(self)
	return self.total_rmb
end
