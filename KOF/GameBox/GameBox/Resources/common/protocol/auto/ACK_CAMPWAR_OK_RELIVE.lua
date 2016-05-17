
require "common/AcknowledgementMessage"

-- (手动) -- [45780]复活成功（废） -- 活动-阵营战 

ACK_CAMPWAR_OK_RELIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_OK_RELIVE
	self:init()
end)
