
require "common/AcknowledgementMessage"

-- [41520]创建成功 -- 年兽 

ACK_NIANSHOU_CREAT_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NIANSHOU_CREAT_OK
	self:init()
end)
