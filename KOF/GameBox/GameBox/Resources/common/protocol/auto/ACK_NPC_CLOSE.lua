
require "common/AcknowledgementMessage"

-- [26015]关闭组队面板 -- NPC 

ACK_NPC_CLOSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NPC_CLOSE
	self:init()
end)
