
require "common/AcknowledgementMessage"

-- (手动) -- [22840]改变宠物状态成功 -- 宠物 

ACK_PET_CHANGE_STATE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_CHANGE_STATE_OK
	self:init()
end)

function ACK_PET_CHANGE_STATE_OK.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {状态值(见常量：CONST_PET_STATE_*)}
end

-- {状态值(见常量：CONST_PET_STATE_*)}
function ACK_PET_CHANGE_STATE_OK.getState(self)
	return self.state
end
