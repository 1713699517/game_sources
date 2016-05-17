
require "common/RequestMessage"

-- [33360]请求开始体能训练 -- 社团 

REQ_CLAN_ASK_START_STR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_START_STR
	self:init(1 ,{ 33370,700 })
end)

function REQ_CLAN_ASK_START_STR.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {训练类型}
end

function REQ_CLAN_ASK_START_STR.setArguments(self,type)
	self.type = type  -- {训练类型}
end

-- {训练类型}
function REQ_CLAN_ASK_START_STR.setType(self, type)
	self.type = type
end
function REQ_CLAN_ASK_START_STR.getType(self)
	return self.type
end
