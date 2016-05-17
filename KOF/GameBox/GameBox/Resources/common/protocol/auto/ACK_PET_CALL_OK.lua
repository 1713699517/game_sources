
require "common/AcknowledgementMessage"

-- [22860]召唤式神成功返回 -- 宠物 

ACK_PET_CALL_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_CALL_OK
	self:init()
end)
