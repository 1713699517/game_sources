
require "common/RequestMessage"

-- [2300]请求商店信息 -- 物品/背包 

REQ_GOODS_SHOP_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_SHOP_ASK
	self:init(0, nil)
end)

function REQ_GOODS_SHOP_ASK.serialize(self, writer)
	writer:writeInt32Unsigned(self.npc_id)  -- {npc_id}
end

function REQ_GOODS_SHOP_ASK.setArguments(self,npc_id)
	self.npc_id = npc_id  -- {npc_id}
end

-- {npc_id}
function REQ_GOODS_SHOP_ASK.setNpcId(self, npc_id)
	self.npc_id = npc_id
end
function REQ_GOODS_SHOP_ASK.getNpcId(self)
	return self.npc_id
end
