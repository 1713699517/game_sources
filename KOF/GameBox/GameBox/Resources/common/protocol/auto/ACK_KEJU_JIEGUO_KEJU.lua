
require "common/AcknowledgementMessage"

-- [44540]每日答题结果 -- 御前科举 

ACK_KEJU_JIEGUO_KEJU = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KEJU_JIEGUO_KEJU
	self:init()
end)

function ACK_KEJU_JIEGUO_KEJU.deserialize(self, reader)
	self.question_id = reader:readInt16Unsigned() -- {题目id}
	self.data = reader:readInt8Unsigned() -- {答案1|2|3}
	self.respone = reader:readInt8Unsigned() -- {正确与否1正确|0错误}
end

-- {题目id}
function ACK_KEJU_JIEGUO_KEJU.getQuestionId(self)
	return self.question_id
end

-- {答案1|2|3}
function ACK_KEJU_JIEGUO_KEJU.getData(self)
	return self.data
end

-- {正确与否1正确|0错误}
function ACK_KEJU_JIEGUO_KEJU.getRespone(self)
	return self.respone
end
