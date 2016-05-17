
require "common/RequestMessage"

-- (手动) -- [9550]屏蔽用户消息 -- 聊天 

REQ_CHAT_SHIELD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_SHIELD
	self:init()
end)

function REQ_CHAT_SHIELD.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {所屏蔽用户id}
end

function REQ_CHAT_SHIELD.setArguments(self,uid)
	self.uid = uid  -- {所屏蔽用户id}
end

-- {所屏蔽用户id}
function REQ_CHAT_SHIELD.setUid(self, uid)
	self.uid = uid
end
function REQ_CHAT_SHIELD.getUid(self)
	return self.uid
end
