
require "common/AcknowledgementMessage"

-- [5190]玩家|伙伴血量更新 -- 场景 

ACK_SCENE_HP_UPDATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_HP_UPDATE
	self:init()
end)

function ACK_SCENE_HP_UPDATE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见：CONST_*}
	self.uid = reader:readInt32Unsigned() -- {玩家ID}
	self.partner_id = reader:readInt32Unsigned() -- {伙伴ID}
	self.stata = reader:readInt8Unsigned() -- {见常量?CONST_WAR_DISPLAY_}
	self.hp_now = reader:readInt32Unsigned() -- {当前血量}
end

-- {详见：CONST_*}
function ACK_SCENE_HP_UPDATE.getType(self)
	return self.type
end

-- {玩家ID}
function ACK_SCENE_HP_UPDATE.getUid(self)
	return self.uid
end

-- {伙伴ID}
function ACK_SCENE_HP_UPDATE.getPartnerId(self)
	return self.partner_id
end

-- {见常量?CONST_WAR_DISPLAY_}
function ACK_SCENE_HP_UPDATE.getStata(self)
	return self.stata
end

-- {当前血量}
function ACK_SCENE_HP_UPDATE.getHpNow(self)
	return self.hp_now
end
