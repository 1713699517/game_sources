
require "common/RequestMessage"

-- (手动) -- [47230]一键打造请求 -- 藏宝阁系统 

REQ_TREASURE_KEY_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_KEY_REQUEST
	self:init()
end)

function REQ_TREASURE_KEY_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.level_id)  -- {层次id}
	writer:writeInt32Unsigned(self.goods_id)  -- {打造物品id}
end

function REQ_TREASURE_KEY_REQUEST.setArguments(self,level_id,goods_id)
	self.level_id = level_id  -- {层次id}
	self.goods_id = goods_id  -- {打造物品id}
end

-- {层次id}
function REQ_TREASURE_KEY_REQUEST.setLevelId(self, level_id)
	self.level_id = level_id
end
function REQ_TREASURE_KEY_REQUEST.getLevelId(self)
	return self.level_id
end

-- {打造物品id}
function REQ_TREASURE_KEY_REQUEST.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_TREASURE_KEY_REQUEST.getGoodsId(self)
	return self.goods_id
end
