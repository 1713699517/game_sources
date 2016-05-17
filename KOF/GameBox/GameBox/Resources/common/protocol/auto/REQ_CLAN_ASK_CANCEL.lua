
require "common/RequestMessage"

-- [33037]请求|取消入帮申请 -- 社团 

REQ_CLAN_ASK_CANCEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_CANCEL
	self:init(1 ,{ 33040,700 })
end)

function REQ_CLAN_ASK_CANCEL.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {操作类型0取消| 1申请}
	writer:writeInt32Unsigned(self.clan_id)  -- {帮派ID 接【33045】}
end

function REQ_CLAN_ASK_CANCEL.setArguments(self,type,clan_id)
	self.type = type  -- {操作类型0取消| 1申请}
	self.clan_id = clan_id  -- {帮派ID 接【33045】}
end

-- {操作类型0取消| 1申请}
function REQ_CLAN_ASK_CANCEL.setType(self, type)
	self.type = type
end
function REQ_CLAN_ASK_CANCEL.getType(self)
	return self.type
end

-- {帮派ID 接【33045】}
function REQ_CLAN_ASK_CANCEL.setClanId(self, clan_id)
	self.clan_id = clan_id
end
function REQ_CLAN_ASK_CANCEL.getClanId(self)
	return self.clan_id
end
