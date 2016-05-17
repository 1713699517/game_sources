
require "common/RequestMessage"

-- [12102]得到默认坐骑 -- 坐骑 

REQ_MOUNT_DEFAULT_MOUNT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_DEFAULT_MOUNT
	self:init(0, nil)
end)
