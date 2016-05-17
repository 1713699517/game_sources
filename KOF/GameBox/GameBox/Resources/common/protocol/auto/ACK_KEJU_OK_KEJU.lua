
require "common/AcknowledgementMessage"

-- [44520]请求面板成功 -- 御前科举 

ACK_KEJU_OK_KEJU = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KEJU_OK_KEJU
	self:init()
end)

function ACK_KEJU_OK_KEJU.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {答题类型0每日|1周末}
	self.num = reader:readInt8Unsigned() -- {记录已答题目数量}
	self.question_id = reader:readInt16Unsigned() -- {问题id}
end

-- {答题类型0每日|1周末}
function ACK_KEJU_OK_KEJU.getType(self)
	return self.type
end

-- {记录已答题目数量}
function ACK_KEJU_OK_KEJU.getNum(self)
	return self.num
end

-- {问题id}
function ACK_KEJU_OK_KEJU.getQuestionId(self)
	return self.question_id
end
