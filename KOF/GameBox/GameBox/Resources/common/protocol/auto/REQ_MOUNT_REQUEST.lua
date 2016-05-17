
require "common/RequestMessage"

-- [12130]坐骑系统请求 -- 坐骑 

REQ_MOUNT_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_REQUEST
	self:init(0, nil)
end)
