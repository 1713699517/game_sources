
require "common/AcknowledgementMessage"

-- [12156]幻化坐骑返回单元 -- 坐骑 

ACK_MOUNT_LLUSION_REPLY_E = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_LLUSION_REPLY_E
	self:init()
end)

-- {坐骑ID}
function ACK_MOUNT_LLUSION_REPLY_E.getMountId(self)
	return self.mount_id
end

-- {0：玩家使用中 | 1：已开启幻化过但当前未使用 | 2：从未幻化过}
function ACK_MOUNT_LLUSION_REPLY_E.getState(self)
	return self.state
end
