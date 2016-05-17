
require "common/AcknowledgementMessage"

-- [12125]幻化请求返回 -- 坐骑 

ACK_MOUNT_LLUSION_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_LLUSION_REPLY
	self:init()
end)

-- {已拥有坐骑数量}
function ACK_MOUNT_LLUSION_REPLY.getCount(self)
	return self.count
end

-- {信息块（12156）}
function ACK_MOUNT_LLUSION_REPLY.getData(self)
	return self.data
end
