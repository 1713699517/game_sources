
require "common/RequestMessage"

-- [2100]丢弃物品 -- 物品/背包 

REQ_GOODS_LOSE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_LOSE
	self:init(1 ,{ 2040,700 })
end)

function REQ_GOODS_LOSE.serialize(self, writer)
	writer:writeInt16Unsigned(self.index)  -- {物品在背包中的下标}
end

function REQ_GOODS_LOSE.setArguments(self,index)
	self.index = index  -- {物品在背包中的下标}
end

-- {物品在背包中的下标}
function REQ_GOODS_LOSE.setIndex(self, index)
	self.index = index
end
function REQ_GOODS_LOSE.getIndex(self)
	return self.index
end
