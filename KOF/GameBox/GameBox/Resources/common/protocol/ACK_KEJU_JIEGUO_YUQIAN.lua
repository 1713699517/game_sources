
require "common/AcknowledgementMessage"

-- [44550]御前科举答题结果 -- 御前科举 

ACK_KEJU_JIEGUO_YUQIAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KEJU_JIEGUO_YUQIAN
	self:init()
end)

-- {题目id}
function ACK_KEJU_JIEGUO_YUQIAN.getQuestionId(self)
	return self.question_id
end

-- {答案1|2|3}
function ACK_KEJU_JIEGUO_YUQIAN.getData(self)
	return self.data
end

-- {正确与否1正确|0错误}
function ACK_KEJU_JIEGUO_YUQIAN.getRespone(self)
	return self.respone
end

-- {得分}
function ACK_KEJU_JIEGUO_YUQIAN.getScore(self)
	return self.score
end

-- {数量}
function ACK_KEJU_JIEGUO_YUQIAN.getCount(self)
	return self.count
end

-- {44555}
function ACK_KEJU_JIEGUO_YUQIAN.getRank(self)
	return self.rank
end
