
require "common/RequestMessage"

-- [48380]请求移动斗气位置 -- 斗气系统 

REQ_SYS_DOUQI_ASK_USE_DOUQI = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_USE_DOUQI
	self:init(1 ,{ 48390,700 })
end)

function REQ_SYS_DOUQI_ASK_USE_DOUQI.serialize(self, writer)
	writer:writeInt16Unsigned(self.role_id)  -- {伙伴ID | 0 自己，仓库}
	writer:writeInt32Unsigned(self.dq_id)  -- {斗气唯一ID}
	writer:writeInt8Unsigned(self.lanid_start)  -- {起始位置}
	writer:writeInt8Unsigned(self.lanid_end)  -- {目标位置}
end

function REQ_SYS_DOUQI_ASK_USE_DOUQI.setArguments(self,role_id,dq_id,lanid_start,lanid_end)
	self.role_id = role_id  -- {伙伴ID | 0 自己，仓库}
	self.dq_id = dq_id  -- {斗气唯一ID}
	self.lanid_start = lanid_start  -- {起始位置}
	self.lanid_end = lanid_end  -- {目标位置}
end

-- {伙伴ID | 0 自己，仓库}
function REQ_SYS_DOUQI_ASK_USE_DOUQI.setRoleId(self, role_id)
	self.role_id = role_id
end
function REQ_SYS_DOUQI_ASK_USE_DOUQI.getRoleId(self)
	return self.role_id
end

-- {斗气唯一ID}
function REQ_SYS_DOUQI_ASK_USE_DOUQI.setDqId(self, dq_id)
	self.dq_id = dq_id
end
function REQ_SYS_DOUQI_ASK_USE_DOUQI.getDqId(self)
	return self.dq_id
end

-- {起始位置}
function REQ_SYS_DOUQI_ASK_USE_DOUQI.setLanidStart(self, lanid_start)
	self.lanid_start = lanid_start
end
function REQ_SYS_DOUQI_ASK_USE_DOUQI.getLanidStart(self)
	return self.lanid_start
end

-- {目标位置}
function REQ_SYS_DOUQI_ASK_USE_DOUQI.setLanidEnd(self, lanid_end)
	self.lanid_end = lanid_end
end
function REQ_SYS_DOUQI_ASK_USE_DOUQI.getLanidEnd(self)
	return self.lanid_end
end
