
require "common/AcknowledgementMessage"

-- [22250]找回经验数据 -- 福利 

ACK_WELFARE_RECOVER_EXP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_RECOVER_EXP
	self:init()
end)
