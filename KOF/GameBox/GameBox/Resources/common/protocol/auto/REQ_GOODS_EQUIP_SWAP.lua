
require "common/RequestMessage"

-- [2270]装备一键互换 -- 物品/背包 

REQ_GOODS_EQUIP_SWAP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_EQUIP_SWAP
	self:init(0, nil)
end)

function REQ_GOODS_EQUIP_SWAP.serialize(self, writer)
	writer:writeInt32Unsigned(self.id1)  -- {武将id1(主将为0)}
	writer:writeInt32Unsigned(self.id2)  -- {武将id2(主将为0)}
end

function REQ_GOODS_EQUIP_SWAP.setArguments(self,id1,id2)
	self.id1 = id1  -- {武将id1(主将为0)}
	self.id2 = id2  -- {武将id2(主将为0)}
end

-- {武将id1(主将为0)}
function REQ_GOODS_EQUIP_SWAP.setId1(self, id1)
	self.id1 = id1
end
function REQ_GOODS_EQUIP_SWAP.getId1(self)
	return self.id1
end

-- {武将id2(主将为0)}
function REQ_GOODS_EQUIP_SWAP.setId2(self, id2)
	self.id2 = id2
end
function REQ_GOODS_EQUIP_SWAP.getId2(self)
	return self.id2
end
