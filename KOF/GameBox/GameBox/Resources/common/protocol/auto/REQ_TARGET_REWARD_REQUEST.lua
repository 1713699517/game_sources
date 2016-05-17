
require "common/RequestMessage"

-- [38030]领取目标奖励 -- 目标任务 

REQ_TARGET_REWARD_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TARGET_REWARD_REQUEST
	self:init(0, nil)
end)

function REQ_TARGET_REWARD_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.serial)  -- {目标序号}
end

function REQ_TARGET_REWARD_REQUEST.setArguments(self,serial)
	self.serial = serial  -- {目标序号}
end

-- {目标序号}
function REQ_TARGET_REWARD_REQUEST.setSerial(self, serial)
	self.serial = serial
end
function REQ_TARGET_REWARD_REQUEST.getSerial(self)
	return self.serial
end
