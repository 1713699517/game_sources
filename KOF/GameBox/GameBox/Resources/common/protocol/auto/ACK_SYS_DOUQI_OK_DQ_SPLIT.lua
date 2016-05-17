
require "common/AcknowledgementMessage"

-- [48330]分解斗气成功 -- 斗气系统 

ACK_SYS_DOUQI_OK_DQ_SPLIT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_DQ_SPLIT
	self:init()
end)

function ACK_SYS_DOUQI_OK_DQ_SPLIT.deserialize(self, reader)
	self.role_id = reader:readInt16Unsigned() -- {伙伴ID   0自己}
	self.lan_id = reader:readInt8Unsigned() -- {斗气栏ID}
	self.get_adams = reader:readInt32Unsigned() -- {获得斗魂数量}
end

-- {伙伴ID   0自己}
function ACK_SYS_DOUQI_OK_DQ_SPLIT.getRoleId(self)
	return self.role_id
end

-- {斗气栏ID}
function ACK_SYS_DOUQI_OK_DQ_SPLIT.getLanId(self)
	return self.lan_id
end

-- {获得斗魂数量}
function ACK_SYS_DOUQI_OK_DQ_SPLIT.getGetAdams(self)
	return self.get_adams
end
