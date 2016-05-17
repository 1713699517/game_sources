
require "common/RequestMessage"

-- [2240]请求角色装备信息 -- 物品/背包 

REQ_GOODS_EQUIP_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_EQUIP_ASK
	self:init(1 ,{ 2242,700 })
end)

function REQ_GOODS_EQUIP_ASK.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家uid}
	writer:writeInt32Unsigned(self.partner)  -- {主将:0|武将id}
end

function REQ_GOODS_EQUIP_ASK.setArguments(self,uid,partner)
	self.uid = uid  -- {玩家uid}
	self.partner = partner  -- {主将:0|武将id}
end

-- {玩家uid}
function REQ_GOODS_EQUIP_ASK.setUid(self, uid)
	self.uid = uid
end
function REQ_GOODS_EQUIP_ASK.getUid(self)
	return self.uid
end

-- {主将:0|武将id}
function REQ_GOODS_EQUIP_ASK.setPartner(self, partner)
	self.partner = partner
end
function REQ_GOODS_EQUIP_ASK.getPartner(self)
	return self.partner
end
