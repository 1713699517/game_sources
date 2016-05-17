
require "common/AcknowledgementMessage"

-- [12115]骑乘|下骑成功 -- 坐骑 

ACK_MOUNT_RIDE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_RIDE_OK
	self:init()
end)

function ACK_MOUNT_RIDE_OK.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {坐骑状态}
end

-- {坐骑状态}
function ACK_MOUNT_RIDE_OK.getState(self)
	return self.state
end
