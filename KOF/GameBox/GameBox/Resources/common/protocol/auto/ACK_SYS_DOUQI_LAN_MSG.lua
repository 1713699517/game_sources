
require "common/AcknowledgementMessage"

-- [48295]被吞者位置ID列表 -- 斗气系统 

ACK_SYS_DOUQI_LAN_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_LAN_MSG
	self:init()
end)

function ACK_SYS_DOUQI_LAN_MSG.deserialize(self, reader)
	self.lan_id = reader:readInt8Unsigned() -- {仓库位置ID}
end

-- {仓库位置ID}
function ACK_SYS_DOUQI_LAN_MSG.getLanId(self)
	return self.lan_id
end
