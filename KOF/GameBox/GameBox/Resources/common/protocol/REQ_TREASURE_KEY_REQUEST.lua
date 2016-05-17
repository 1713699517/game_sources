
require "common/RequestMessage"

-- [47235]处理一键打造请求 -- 藏宝阁系统 

REQ_TREASURE_KEY_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_KEY_REQUEST
	self:init()
end)

function REQ_TREASURE_KEY_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.goods_id)  -- {打造物品id}
end

function REQ_TREASURE_KEY_REQUEST.setArguments(self,goods_id)
	self.goods_id = goods_id  -- {打造物品id}
end

-- {打造物品id}
function REQ_TREASURE_KEY_REQUEST.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_TREASURE_KEY_REQUEST.getGoodsId(self)
	return self.goods_id
end
