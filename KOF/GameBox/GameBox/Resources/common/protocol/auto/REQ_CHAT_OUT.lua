
require "common/RequestMessage"

-- (手动) -- [9520]离开频道 -- 聊天 

REQ_CHAT_OUT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_OUT
	self:init()
end)

function REQ_CHAT_OUT.serialize(self, writer)
	writer:writeInt8Unsigned(self.channel_id)  -- {频道类型}
end

function REQ_CHAT_OUT.setArguments(self,channel_id)
	self.channel_id = channel_id  -- {频道类型}
end

-- {频道类型}
function REQ_CHAT_OUT.setChannelId(self, channel_id)
	self.channel_id = channel_id
end
function REQ_CHAT_OUT.getChannelId(self)
	return self.channel_id
end
