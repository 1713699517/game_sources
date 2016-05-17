
require "common/AcknowledgementMessage"

-- [21250]复活成功 -- 活动-保卫经书 

ACK_DEFEND_BOOK_OK_REVIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_OK_REVIVE
	self:init()
end)
