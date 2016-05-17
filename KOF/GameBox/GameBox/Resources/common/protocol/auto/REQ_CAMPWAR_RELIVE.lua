
require "common/RequestMessage"

-- (手动) -- [45770]复活（废） -- 活动-阵营战 

REQ_CAMPWAR_RELIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_RELIVE
	self:init()
end)

function REQ_CAMPWAR_RELIVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {复活类型1金元|0普通 0可不发}
end

function REQ_CAMPWAR_RELIVE.setArguments(self,type)
	self.type = type  -- {复活类型1金元|0普通 0可不发}
end

-- {复活类型1金元|0普通 0可不发}
function REQ_CAMPWAR_RELIVE.setType(self, type)
	self.type = type
end
function REQ_CAMPWAR_RELIVE.getType(self)
	return self.type
end
