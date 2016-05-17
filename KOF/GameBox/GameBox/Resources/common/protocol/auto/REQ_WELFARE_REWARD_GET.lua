
require "common/RequestMessage"

-- [22260]领取奖励 -- 福利 

REQ_WELFARE_REWARD_GET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WELFARE_REWARD_GET
	self:init(0, nil)
end)

function REQ_WELFARE_REWARD_GET.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {奖励类型}
	writer:writeInt32Unsigned(self.condition)  -- {奖励条件值}
end

function REQ_WELFARE_REWARD_GET.setArguments(self,type,condition)
	self.type = type  -- {奖励类型}
	self.condition = condition  -- {奖励条件值}
end

-- {奖励类型}
function REQ_WELFARE_REWARD_GET.setType(self, type)
	self.type = type
end
function REQ_WELFARE_REWARD_GET.getType(self)
	return self.type
end

-- {奖励条件值}
function REQ_WELFARE_REWARD_GET.setCondition(self, condition)
	self.condition = condition
end
function REQ_WELFARE_REWARD_GET.getCondition(self)
	return self.condition
end
