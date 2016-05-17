
require "common/AcknowledgementMessage"

-- (手动) -- [32085]财神符面板返回 -- 财神 

ACK_WEAGOD_WEAPRO_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_WEAPRO_REPLY
	self:init()
end)

function ACK_WEAGOD_WEAPRO_REPLY.deserialize(self, reader)
	self.prolv = reader:readInt8Unsigned() -- {财神等级}
	self.pronum = reader:readInt8Unsigned() -- {财神符数量}
	self.gold = reader:readInt32Unsigned() -- {普通玩家银元奖励}
	self.vip_gold = reader:readInt32Unsigned() -- {VIP银元奖励}
	self.vip_rmb = reader:readInt16Unsigned() -- {VIP金元奖励}
end

-- {财神等级}
function ACK_WEAGOD_WEAPRO_REPLY.getProlv(self)
	return self.prolv
end

-- {财神符数量}
function ACK_WEAGOD_WEAPRO_REPLY.getPronum(self)
	return self.pronum
end

-- {普通玩家银元奖励}
function ACK_WEAGOD_WEAPRO_REPLY.getGold(self)
	return self.gold
end

-- {VIP银元奖励}
function ACK_WEAGOD_WEAPRO_REPLY.getVipGold(self)
	return self.vip_gold
end

-- {VIP金元奖励}
function ACK_WEAGOD_WEAPRO_REPLY.getVipRmb(self)
	return self.vip_rmb
end
