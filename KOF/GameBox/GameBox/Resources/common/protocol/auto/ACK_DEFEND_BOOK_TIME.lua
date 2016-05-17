
require "common/AcknowledgementMessage"

-- [21122]倒计时 -- 活动-保卫经书 

ACK_DEFEND_BOOK_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_TIME
	self:init()
end)

function ACK_DEFEND_BOOK_TIME.deserialize(self, reader)
	self.time_value = reader:readInt16Unsigned() -- {当前倒计时秒数}
end

-- {当前倒计时秒数}
function ACK_DEFEND_BOOK_TIME.getTimeValue(self)
	return self.time_value
end
