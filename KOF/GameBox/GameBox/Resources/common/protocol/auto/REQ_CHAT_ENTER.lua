
require "common/RequestMessage"

-- (手动) -- [9510]进入频道 -- 聊天 

REQ_CHAT_ENTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_ENTER
	self:init()
end)

function REQ_CHAT_ENTER.serialize(self, writer)
	writer:writeInt8Unsigned(self.channel_id)  -- {频道类型}
end

function REQ_CHAT_ENTER.setArguments(self,channel_id)
	self.channel_id = channel_id  -- {频道类型}
end

-- {频道类型}
function REQ_CHAT_ENTER.setChannelId(self, channel_id)
	self.channel_id = channel_id
end
function REQ_CHAT_ENTER.getChannelId(self)
	return self.channel_id
end
