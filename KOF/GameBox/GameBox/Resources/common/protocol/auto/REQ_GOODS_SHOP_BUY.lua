
require "common/RequestMessage"

-- [2320]购买商店物品 -- 物品/背包 

REQ_GOODS_SHOP_BUY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_SHOP_BUY
	self:init(0, nil)
end)

function REQ_GOODS_SHOP_BUY.serialize(self, writer)
	writer:writeInt16Unsigned(self.npc_id)  -- {npc_id; 0为背包随身商店}
	writer:writeInt32Unsigned(self.goods_id)  -- {物品ID}
	writer:writeInt16Unsigned(self.count)  -- {购买数量}
end

function REQ_GOODS_SHOP_BUY.setArguments(self,npc_id,goods_id,count)
	self.npc_id = npc_id  -- {npc_id; 0为背包随身商店}
	self.goods_id = goods_id  -- {物品ID}
	self.count = count  -- {购买数量}
end

-- {npc_id; 0为背包随身商店}
function REQ_GOODS_SHOP_BUY.setNpcId(self, npc_id)
	self.npc_id = npc_id
end
function REQ_GOODS_SHOP_BUY.getNpcId(self)
	return self.npc_id
end

-- {物品ID}
function REQ_GOODS_SHOP_BUY.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_GOODS_SHOP_BUY.getGoodsId(self)
	return self.goods_id
end

-- {购买数量}
function REQ_GOODS_SHOP_BUY.setCount(self, count)
	self.count = count
end
function REQ_GOODS_SHOP_BUY.getCount(self)
	return self.count
end
