
require "common/AcknowledgementMessage"

-- [42512]卡片活动开放结果 -- 收集卡片 

ACK_COLLECT_CARD_LIMIT_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_LIMIT_RESULT
	self:init()
end)

function ACK_COLLECT_CARD_LIMIT_RESULT.deserialize(self, reader)
	self.result = reader:readBoolean() -- {true:有|false:无}
	self.seconds_s = reader:readInt32Unsigned() -- {开始日期时间戳}
	self.seconds_e = reader:readInt32Unsigned() -- {结束日期时间戳}
end

-- {true:有|false:无}
function ACK_COLLECT_CARD_LIMIT_RESULT.getResult(self)
	return self.result
end

-- {开始日期时间戳}
function ACK_COLLECT_CARD_LIMIT_RESULT.getSecondsS(self)
	return self.seconds_s
end

-- {结束日期时间戳}
function ACK_COLLECT_CARD_LIMIT_RESULT.getSecondsE(self)
	return self.seconds_e
end
