
require "common/AcknowledgementMessage"

-- [22840]开启式神ok -- 宠物 

ACK_PET_OPEN_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_OPEN_OK
	self:init()
end)
