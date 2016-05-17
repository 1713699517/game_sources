
require "common/AcknowledgementMessage"

-- [9527]玩家不在线 -- 聊天 

ACK_CHAT_OFFICE_PLAYER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CHAT_OFFICE_PLAYER
	self:init()
end)
