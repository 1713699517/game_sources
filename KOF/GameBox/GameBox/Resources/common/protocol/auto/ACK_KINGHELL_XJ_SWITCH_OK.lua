
require "common/AcknowledgementMessage"

-- [44705]心经互换成功 -- 阎王殿 

ACK_KINGHELL_XJ_SWITCH_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_XJ_SWITCH_OK
	self:init()
end)
