
require "common/AcknowledgementMessage"
require "common/protocol/ACK_GOODS_XXX2"
-- [1109]伙伴属性 -- 角色

ACK_ROLE_PARTNER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_PARTNER_DATA
	self:init()
end)

function ACK_ROLE_PARTNER_DATA.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {所属玩家Uid}
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
	self.partner_pro = reader:readInt8Unsigned() -- {伙伴职业}
	self.partner_lv = reader:readInt8Unsigned() -- {伙伴等级}
	self.exp = reader:readInt32Unsigned() -- {经验}
	self.next_exp = reader:readInt32Unsigned() -- {下一级经验}
	self.powerful = reader:readInt32Unsigned() -- {战斗力}
	self.stata = reader:readInt8Unsigned() -- {伙伴状态}
	--self.attr = reader:readXXXGroup() -- {基础信息块2002}
    self.attr = ACK_GOODS_XXX2()
    self.attr : deserialize( reader )
end

-- {所属玩家Uid}
function ACK_ROLE_PARTNER_DATA.getUid(self)
	return self.uid
end

-- {伙伴ID}
function ACK_ROLE_PARTNER_DATA.getPartnerId(self)
	return self.partner_id
end

-- {伙伴职业}
function ACK_ROLE_PARTNER_DATA.getPartnerPro(self)
	return self.partner_pro
end

-- {伙伴等级}
function ACK_ROLE_PARTNER_DATA.getPartnerLv(self)
	return self.partner_lv
end

-- {经验}
function ACK_ROLE_PARTNER_DATA.getExp(self)
	return self.exp
end

-- {下一级经验}
function ACK_ROLE_PARTNER_DATA.getNextExp(self)
	return self.next_exp
end

-- {战斗力}
function ACK_ROLE_PARTNER_DATA.getPowerful(self)
	return self.powerful
end

-- {伙伴状态}
function ACK_ROLE_PARTNER_DATA.getStata(self)
	return self.stata
end

-- {基础信息块2002}
function ACK_ROLE_PARTNER_DATA.getAttr(self)
	return self.attr
end
