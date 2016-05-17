
require "common/AcknowledgementMessage"

-- [12103]成功得到默认坐骑 -- 坐骑 

ACK_MOUNT_DEFAULT_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_DEFAULT_SUCCESS
	self:init()
end)
