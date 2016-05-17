
require "common/AcknowledgementMessage"

-- [31200]返回伙伴品质精魄数量 -- 客栈 

ACK_INN_RES_CONTEST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_RES_CONTEST
	self:init()
end)

-- {回合数量}
function ACK_INN_RES_CONTEST.getRoundCount(self)
	return self.round_count
end

-- {颜色数量}
function ACK_INN_RES_CONTEST.getCount(self)
	return self.count
end

-- {31110}
function ACK_INN_RES_CONTEST.getSoul(self)
	return self.soul
end
