
require "common/RequestMessage"

-- [12120]幻化请求 -- 坐骑 

REQ_MOUNT_LLUSION = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_LLUSION
	self:init(0, nil)
end)
