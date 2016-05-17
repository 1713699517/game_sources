
require "common/AcknowledgementMessage"

-- (手动) -- [22950]宠物进阶结果 -- 宠物 

ACK_PET_STEPS_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_STEPS_RESULT
	self:init()
end)

function ACK_PET_STEPS_RESULT.deserialize(self, reader)
	self.result = reader:readBoolean() -- {true:成功;false:失败}
end

-- {true:成功;false:失败}
function ACK_PET_STEPS_RESULT.getResult(self)
	return self.result
end
