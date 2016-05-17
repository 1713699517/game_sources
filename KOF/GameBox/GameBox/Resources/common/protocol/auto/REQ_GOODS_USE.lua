
require "common/RequestMessage"

-- [2080]物品/装备使用 -- 物品/背包 

REQ_GOODS_USE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_USE
	self:init(1 ,{ 2040,2050,700 })
end)

function REQ_GOODS_USE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
	writer:writeInt32Unsigned(self.target)  -- {对象ID,0:自己|伙伴id}
	writer:writeInt16Unsigned(self.from_index)  -- {所在容器位置索引}
	writer:writeInt16Unsigned(self.count)  -- {使用数量}
end

function REQ_GOODS_USE.setArguments(self,type,target,from_index,count)
	self.type = type  -- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
	self.target = target  -- {对象ID,0:自己|伙伴id}
	self.from_index = from_index  -- {所在容器位置索引}
	self.count = count  -- {使用数量}
end

-- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
function REQ_GOODS_USE.setType(self, type)
	self.type = type
end
function REQ_GOODS_USE.getType(self)
	return self.type
end

-- {对象ID,0:自己|伙伴id}
function REQ_GOODS_USE.setTarget(self, target)
	self.target = target
end
function REQ_GOODS_USE.getTarget(self)
	return self.target
end

-- {所在容器位置索引}
function REQ_GOODS_USE.setFromIndex(self, from_index)
	self.from_index = from_index
end
function REQ_GOODS_USE.getFromIndex(self)
	return self.from_index
end

-- {使用数量}
function REQ_GOODS_USE.setCount(self, count)
	self.count = count
end
function REQ_GOODS_USE.getCount(self)
	return self.count
end
