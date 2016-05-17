
require "common/AcknowledgementMessage"

-- [10022]领取祝福经验成功 -- 祝福 

ACK_WISH_EXP_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_EXP_SUCCESS
	self:init()
end)
