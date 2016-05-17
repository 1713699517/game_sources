
require "common/RequestMessage"

-- [48280]请求一键吞噬 -- 斗气系统 

REQ_SYS_DOUQI_ASK_EAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_EAT
	self:init(1 ,{ 48285,700 })
end)

function REQ_SYS_DOUQI_ASK_EAT.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {仓库类型  0领悟仓库| 1装备仓库}
end

function REQ_SYS_DOUQI_ASK_EAT.setArguments(self,type)
	self.type = type  -- {仓库类型  0领悟仓库| 1装备仓库}
end

-- {仓库类型  0领悟仓库| 1装备仓库}
function REQ_SYS_DOUQI_ASK_EAT.setType(self, type)
	self.type = type
end
function REQ_SYS_DOUQI_ASK_EAT.getType(self)
	return self.type
end
