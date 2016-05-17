
require "common/AcknowledgementMessage"

-- [54804]报名状态 -- 格斗之王 

ACK_WRESTLE_APPLY_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_APPLY_STATE
	self:init()
end)
