
require "common/RequestMessage"

-- [44800]请求挑战 -- 阎王殿 

REQ_KINGHELL_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_WAR
	self:init(0, nil)
end)

function REQ_KINGHELL_WAR.serialize(self, writer)
	writer:writeInt16Unsigned(self.king_id)  -- {当前阎王ID}
	writer:writeInt16Unsigned(self.mons_id)  -- {所要挑战的boss ID}
	writer:writeInt8Unsigned(self.type)  -- {当前怪物类型}
	writer:writeInt32Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_KINGHELL_WAR.setArguments(self,king_id,mons_id,type,partner_id)
	self.king_id = king_id  -- {当前阎王ID}
	self.mons_id = mons_id  -- {所要挑战的boss ID}
	self.type = type  -- {当前怪物类型}
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {当前阎王ID}
function REQ_KINGHELL_WAR.setKingId(self, king_id)
	self.king_id = king_id
end
function REQ_KINGHELL_WAR.getKingId(self)
	return self.king_id
end

-- {所要挑战的boss ID}
function REQ_KINGHELL_WAR.setMonsId(self, mons_id)
	self.mons_id = mons_id
end
function REQ_KINGHELL_WAR.getMonsId(self)
	return self.mons_id
end

-- {当前怪物类型}
function REQ_KINGHELL_WAR.setType(self, type)
	self.type = type
end
function REQ_KINGHELL_WAR.getType(self)
	return self.type
end

-- {伙伴ID}
function REQ_KINGHELL_WAR.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_KINGHELL_WAR.getPartnerId(self)
	return self.partner_id
end
