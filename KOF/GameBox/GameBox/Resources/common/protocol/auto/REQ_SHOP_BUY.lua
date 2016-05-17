
require "common/RequestMessage"

-- [34515]请求购买 -- 商城 

REQ_SHOP_BUY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOP_BUY
	self:init(0, nil)
end)

function REQ_SHOP_BUY.serialize(self, writer)
	writer:writeInt16Unsigned(self.type)  -- {店铺类型}
	writer:writeInt16Unsigned(self.type_bb)  -- {子店铺类型}
	writer:writeInt16Unsigned(self.idx)  -- {物品数据索引}
	writer:writeInt16Unsigned(self.goods_id)  -- {物品id}
	writer:writeInt16Unsigned(self.count)  -- {购买数量}
	writer:writeInt16Unsigned(self.ctype)  -- {货币类型}
end

function REQ_SHOP_BUY.setArguments(self,type,type_bb,idx,goods_id,count,ctype)
	self.type = type  -- {店铺类型}
	self.type_bb = type_bb  -- {子店铺类型}
	self.idx = idx  -- {物品数据索引}
	self.goods_id = goods_id  -- {物品id}
	self.count = count  -- {购买数量}
	self.ctype = ctype  -- {货币类型}
end

-- {店铺类型}
function REQ_SHOP_BUY.setType(self, type)
	self.type = type
end
function REQ_SHOP_BUY.getType(self)
	return self.type
end

-- {子店铺类型}
function REQ_SHOP_BUY.setTypeBb(self, type_bb)
	self.type_bb = type_bb
end
function REQ_SHOP_BUY.getTypeBb(self)
	return self.type_bb
end

-- {物品数据索引}
function REQ_SHOP_BUY.setIdx(self, idx)
	self.idx = idx
end
function REQ_SHOP_BUY.getIdx(self)
	return self.idx
end

-- {物品id}
function REQ_SHOP_BUY.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_SHOP_BUY.getGoodsId(self)
	return self.goods_id
end

-- {购买数量}
function REQ_SHOP_BUY.setCount(self, count)
	self.count = count
end
function REQ_SHOP_BUY.getCount(self)
	return self.count
end

-- {货币类型}
function REQ_SHOP_BUY.setCtype(self, ctype)
	self.ctype = ctype
end
function REQ_SHOP_BUY.getCtype(self)
	return self.ctype
end
