
require "common/AcknowledgementMessage"

-- [21170]战壕数据 -- 活动-保卫经书 

ACK_DEFEND_BOOK_TRENCH_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_TRENCH_DATE
	self:init()
end)

-- {数量}
function ACK_DEFEND_BOOK_TRENCH_DATE.getCount(self)
	return self.count
end

-- {战壕信息块[21147]}
function ACK_DEFEND_BOOK_TRENCH_DATE.getDataTrench(self)
	return self.data_trench
end
