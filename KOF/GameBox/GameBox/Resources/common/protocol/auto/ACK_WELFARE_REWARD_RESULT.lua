
require "common/AcknowledgementMessage"

-- [22270]领取奖励结果 -- 福利 

ACK_WELFARE_REWARD_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_REWARD_RESULT
	self:init()
end)

function ACK_WELFARE_REWARD_RESULT.deserialize(self, reader)
	self.result = reader:readBoolean() -- {true:成功 | false:失败}
	self.type = reader:readInt8Unsigned() -- {奖励类型}
	self.condition = reader:readInt32Unsigned() -- {奖励条件值}
end

-- {true:成功 | false:失败}
function ACK_WELFARE_REWARD_RESULT.getResult(self)
	return self.result
end

-- {奖励类型}
function ACK_WELFARE_REWARD_RESULT.getType(self)
	return self.type
end

-- {奖励条件值}
function ACK_WELFARE_REWARD_RESULT.getCondition(self)
	return self.condition
end
