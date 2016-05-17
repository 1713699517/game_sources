
require "common/RequestMessage"

-- [48320]请求分解斗气 -- 斗气系统 

REQ_SYS_DOUQI_DQ_SPLIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_DQ_SPLIT
	self:init(1 ,{ 48330,700 })
end)

function REQ_SYS_DOUQI_DQ_SPLIT.serialize(self, writer)
	writer:writeInt16Unsigned(self.role_id)  -- {伙伴ID   0自己}
	writer:writeInt8Unsigned(self.lan_id)  -- {斗气栏ID}
end

function REQ_SYS_DOUQI_DQ_SPLIT.setArguments(self,role_id,lan_id)
	self.role_id = role_id  -- {伙伴ID   0自己}
	self.lan_id = lan_id  -- {斗气栏ID}
end

-- {伙伴ID   0自己}
function REQ_SYS_DOUQI_DQ_SPLIT.setRoleId(self, role_id)
	self.role_id = role_id
end
function REQ_SYS_DOUQI_DQ_SPLIT.getRoleId(self)
	return self.role_id
end

-- {斗气栏ID}
function REQ_SYS_DOUQI_DQ_SPLIT.setLanId(self, lan_id)
	self.lan_id = lan_id
end
function REQ_SYS_DOUQI_DQ_SPLIT.getLanId(self)
	return self.lan_id
end
