
require "common/RequestMessage"

-- [2260]出售物品 -- 物品/背包 

REQ_GOODS_SELL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_SELL
	self:init(0, nil)
end)

function REQ_GOODS_SELL.serialize(self, writer)
	writer:writeInt16Unsigned(self.idx)  -- {物品索引}
	writer:writeInt16Unsigned(self.num)  -- {物品数量}
end

function REQ_GOODS_SELL.setArguments(self,idx,num)
	self.idx = idx  -- {物品索引}
	self.num = num  -- {物品数量}
end

-- {物品索引}
function REQ_GOODS_SELL.setIdx(self, idx)
	self.idx = idx
end
function REQ_GOODS_SELL.getIdx(self)
	return self.idx
end

-- {物品数量}
function REQ_GOODS_SELL.setNum(self, num)
	self.num = num
end
function REQ_GOODS_SELL.getNum(self)
	return self.num
end
