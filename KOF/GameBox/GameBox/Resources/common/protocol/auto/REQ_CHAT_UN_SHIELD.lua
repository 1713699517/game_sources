
require "common/RequestMessage"

-- (手动) -- [9555]取消屏蔽用户消息 -- 聊天 

REQ_CHAT_UN_SHIELD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_UN_SHIELD
	self:init()
end)

function REQ_CHAT_UN_SHIELD.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {取消屏蔽的用户id}
end

function REQ_CHAT_UN_SHIELD.setArguments(self,uid)
	self.uid = uid  -- {取消屏蔽的用户id}
end

-- {取消屏蔽的用户id}
function REQ_CHAT_UN_SHIELD.setUid(self, uid)
	self.uid = uid
end
function REQ_CHAT_UN_SHIELD.getUid(self)
	return self.uid
end
