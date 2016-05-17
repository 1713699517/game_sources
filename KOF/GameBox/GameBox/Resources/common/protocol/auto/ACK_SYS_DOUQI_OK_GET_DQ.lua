
require "common/AcknowledgementMessage"

-- (手动) -- [48310]拾取成功 -- 斗气系统 

ACK_SYS_DOUQI_OK_GET_DQ = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_GET_DQ
	self:init()
end)

function ACK_SYS_DOUQI_OK_GET_DQ.deserialize(self, reader)
	self.lan_id = reader:readInt8Unsigned() -- {0 一键拾取| ID 栏位ID}
    print("拾取成功 -- 斗气系统:"..self.id)
end

-- {0 一键拾取| ID 栏位ID}
function ACK_SYS_DOUQI_OK_GET_DQ.getLanId(self)
	return self.lan_id
end
