
require "common/AcknowledgementMessage"

-- [48203]斗气信息块 -- 斗气系统 

ACK_SYS_DOUQI_DOUQI_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_DOUQI_DATA
	self:init()
end)

function ACK_SYS_DOUQI_DOUQI_DATA.deserialize(self, reader)
	self.lan_id = reader:readInt8Unsigned() -- {斗气栏编号1-8}
	self.dq_id = reader:readInt32Unsigned() -- {斗气唯一ID}
	self.dq_type = reader:readInt16Unsigned() -- {斗气类型ID}
	self.dq_lv = reader:readInt8Unsigned() -- {斗气等级}
	self.dq_exp = reader:readInt32Unsigned() -- {斗气经验}
	self.is_lock = reader:readInt8Unsigned() -- {是否锁定 0未锁| 1锁定}
end

-- {斗气栏编号1-8}
function ACK_SYS_DOUQI_DOUQI_DATA.getLanId(self)
	return self.lan_id
end

-- {斗气唯一ID}
function ACK_SYS_DOUQI_DOUQI_DATA.getDqId(self)
	return self.dq_id
end

-- {斗气类型ID}
function ACK_SYS_DOUQI_DOUQI_DATA.getDqType(self)
	return self.dq_type
end

-- {斗气等级}
function ACK_SYS_DOUQI_DOUQI_DATA.getDqLv(self)
	return self.dq_lv
end

-- {斗气经验}
function ACK_SYS_DOUQI_DOUQI_DATA.getDqExp(self)
	return self.dq_exp
end

-- {是否锁定 0未锁| 1锁定}
function ACK_SYS_DOUQI_DOUQI_DATA.getIsLock(self)
	return self.is_lock
end
