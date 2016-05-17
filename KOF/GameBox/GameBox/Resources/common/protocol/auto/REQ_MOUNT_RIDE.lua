
require "common/RequestMessage"

-- [12110]骑乘|下骑 -- 坐骑 

REQ_MOUNT_RIDE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_RIDE
	self:init(0, nil)
end)
