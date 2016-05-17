
require "common/AcknowledgementMessage"

-- [47240]返回打造物品所需材料信息块 -- 藏宝阁系统 

ACK_TREASURE_GOODS_MAKE_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_GOODS_MAKE_INFO
	self:init()
end)

function ACK_TREASURE_GOODS_MAKE_INFO.deserialize(self, reader)
	self.makings_id = reader:readInt32Unsigned() -- {材料id}
	self.makings_count = reader:readInt16Unsigned() -- {该材料当前数量}
	self.makings_sum = reader:readInt16Unsigned() -- {该材料所需数量}
end

-- {材料id}
function ACK_TREASURE_GOODS_MAKE_INFO.getMakingsId(self)
	return self.makings_id
end

-- {该材料当前数量}
function ACK_TREASURE_GOODS_MAKE_INFO.getMakingsCount(self)
	return self.makings_count
end

-- {该材料所需数量}
function ACK_TREASURE_GOODS_MAKE_INFO.getMakingsSum(self)
	return self.makings_sum
end
