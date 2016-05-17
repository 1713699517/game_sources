
require "common/RequestMessage"

-- [2090]使用物品(指定对象) -- 物品/背包 

REQ_GOODS_TARGET_USE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_TARGET_USE
	self:init(0, nil)
end)

function REQ_GOODS_TARGET_USE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
	writer:writeInt32Unsigned(self.target)  -- {物品位置对象ID,0:自己|伙伴id}
	writer:writeInt16Unsigned(self.from_idx)  -- {所在容器位置索引}
	writer:writeInt16Unsigned(self.count)  -- {使用数量}
	writer:writeInt32Unsigned(self.object)  -- {使用目标(0:主将|其他:武将ID)}
end

function REQ_GOODS_TARGET_USE.setArguments(self,type,target,from_idx,count,object)
	self.type = type  -- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
	self.target = target  -- {物品位置对象ID,0:自己|伙伴id}
	self.from_idx = from_idx  -- {所在容器位置索引}
	self.count = count  -- {使用数量}
	self.object = object  -- {使用目标(0:主将|其他:武将ID)}
end

-- {1:背包(使,装) 2:人物装备(卸) 3:临时背包(取)}
function REQ_GOODS_TARGET_USE.setType(self, type)
	self.type = type
end
function REQ_GOODS_TARGET_USE.getType(self)
	return self.type
end

-- {物品位置对象ID,0:自己|伙伴id}
function REQ_GOODS_TARGET_USE.setTarget(self, target)
	self.target = target
end
function REQ_GOODS_TARGET_USE.getTarget(self)
	return self.target
end

-- {所在容器位置索引}
function REQ_GOODS_TARGET_USE.setFromIdx(self, from_idx)
	self.from_idx = from_idx
end
function REQ_GOODS_TARGET_USE.getFromIdx(self)
	return self.from_idx
end

-- {使用数量}
function REQ_GOODS_TARGET_USE.setCount(self, count)
	self.count = count
end
function REQ_GOODS_TARGET_USE.getCount(self)
	return self.count
end

-- {使用目标(0:主将|其他:武将ID)}
function REQ_GOODS_TARGET_USE.setObject(self, object)
	self.object = object
end
function REQ_GOODS_TARGET_USE.getObject(self)
	return self.object
end
