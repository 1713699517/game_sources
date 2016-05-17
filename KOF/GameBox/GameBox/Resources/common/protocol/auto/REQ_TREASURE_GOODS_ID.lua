
require "common/RequestMessage"

-- [47220]物品打造数据请求 -- 珍宝阁系统 

REQ_TREASURE_GOODS_ID = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_GOODS_ID
	self:init(1 ,{ 47230,700 })
end)

function REQ_TREASURE_GOODS_ID.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:普通打造|1:一键打造}
	writer:writeInt8Unsigned(self.level_id)  -- {层次id}
	writer:writeInt32Unsigned(self.goods_id)  -- {打造物品id}
end

function REQ_TREASURE_GOODS_ID.setArguments(self,type,level_id,goods_id)
	self.type = type  -- {0:普通打造|1:一键打造}
	self.level_id = level_id  -- {层次id}
	self.goods_id = goods_id  -- {打造物品id}
end

-- {0:普通打造|1:一键打造}
function REQ_TREASURE_GOODS_ID.setType(self, type)
	self.type = type
end
function REQ_TREASURE_GOODS_ID.getType(self)
	return self.type
end

-- {层次id}
function REQ_TREASURE_GOODS_ID.setLevelId(self, level_id)
	self.level_id = level_id
end
function REQ_TREASURE_GOODS_ID.getLevelId(self)
	return self.level_id
end

-- {打造物品id}
function REQ_TREASURE_GOODS_ID.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_TREASURE_GOODS_ID.getGoodsId(self)
	return self.goods_id
end
