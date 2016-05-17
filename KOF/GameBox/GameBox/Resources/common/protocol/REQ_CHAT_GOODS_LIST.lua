
require "common/RequestMessage"

-- [9524]收到频道聊天 -- 聊天 

REQ_CHAT_GOODS_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_GOODS_LIST
	self:init(0, nil)
end)

function REQ_CHAT_GOODS_LIST.serialize(self, writer)
	writer:writeInt8Unsigned(self.goods_type)  -- {1:背包 2:装备 3:仓库 4:宝箱仓库 5:临时背包}
	writer:writeInt32Unsigned(self.id)  -- {主角:0|伙伴ID}
	writer:writeInt16Unsigned(self.goods_index)  -- {所在容器位置索引}
end

function REQ_CHAT_GOODS_LIST.setArguments(self,goods_type,id,goods_index)
	self.goods_type = goods_type  -- {1:背包 2:装备 3:仓库 4:宝箱仓库 5:临时背包}
	self.id = id  -- {主角:0|伙伴ID}
	self.goods_index = goods_index  -- {所在容器位置索引}
end

-- {1:背包 2:装备 3:仓库 4:宝箱仓库 5:临时背包}
function REQ_CHAT_GOODS_LIST.setGoodsType(self, goods_type)
	self.goods_type = goods_type
end
function REQ_CHAT_GOODS_LIST.getGoodsType(self)
	return self.goods_type
end

-- {主角:0|伙伴ID}
function REQ_CHAT_GOODS_LIST.setId(self, id)
	self.id = id
end
function REQ_CHAT_GOODS_LIST.getId(self)
	return self.id
end

-- {所在容器位置索引}
function REQ_CHAT_GOODS_LIST.setGoodsIndex(self, goods_index)
	self.goods_index = goods_index
end
function REQ_CHAT_GOODS_LIST.getGoodsIndex(self)
	return self.goods_index
end
