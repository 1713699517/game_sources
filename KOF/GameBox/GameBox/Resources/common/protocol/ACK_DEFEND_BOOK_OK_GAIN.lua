
require "common/AcknowledgementMessage"

-- [21290]领取增益成功 -- 活动-保卫经书 

ACK_DEFEND_BOOK_OK_GAIN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_OK_GAIN
	self:init()
end)
