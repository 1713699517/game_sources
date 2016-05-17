
require "common/AcknowledgementMessage"

-- [45757]奖励数据块 -- 活动-阵营战 

ACK_CAMPWAR_REWARDS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_REWARDS_DATA
	self:init()
end)

function ACK_CAMPWAR_REWARDS_DATA.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {虚拟物品类型：CONST_CURRENCY_*}
	self.value = reader:readInt32Unsigned() -- {数量}
end

-- {虚拟物品类型：CONST_CURRENCY_*}
function ACK_CAMPWAR_REWARDS_DATA.getType(self)
	return self.type
end

-- {数量}
function ACK_CAMPWAR_REWARDS_DATA.getValue(self)
	return self.value
end
