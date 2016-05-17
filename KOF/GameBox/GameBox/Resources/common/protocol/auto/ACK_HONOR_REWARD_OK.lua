
require "common/AcknowledgementMessage"

-- [18125]领取成功 -- 荣誉 

ACK_HONOR_REWARD_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HONOR_REWARD_OK
	self:init()
end)
