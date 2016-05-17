
require "common/AcknowledgementMessage"

-- [7890]查询章节奖励返回 -- 副本 

ACK_COPY_CHAP_RE_REP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_CHAP_RE_REP
	self:init()
end)

function ACK_COPY_CHAP_RE_REP.deserialize(self, reader)
	self.result = reader:readInt8Unsigned() -- {结果(1：已领取|0：没领取}
end

-- {结果(1：已领取|0：没领取}
function ACK_COPY_CHAP_RE_REP.getResult(self)
	return self.result
end
