
require "common/AcknowledgementMessage"

-- (手动) -- [9515]进入频道 -- 聊天 

ACK_CHAT_ENTER_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CHAT_ENTER_OK
	self:init()
end)

function ACK_CHAT_ENTER_OK.deserialize(self, reader)
	self.channel_id = reader:readInt8Unsigned() -- {频道类型}
	self.cooldown = reader:readInt8Unsigned() -- {冷却时间(秒)}
end

-- {频道类型}
function ACK_CHAT_ENTER_OK.getChannelId(self)
	return self.channel_id
end

-- {冷却时间(秒)}
function ACK_CHAT_ENTER_OK.getCooldown(self)
	return self.cooldown
end
