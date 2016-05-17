
require "common/RequestMessage"

-- [48300]请求拾取斗气 -- 斗气系统 

REQ_SYS_DOUQI_ASK_GET_DQ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_GET_DQ
	self:init(1 ,{ 48310,700 })
end)

function REQ_SYS_DOUQI_ASK_GET_DQ.serialize(self, writer)
	writer:writeInt8Unsigned(self.lan_id)  -- {0 一键拾取| ID 栏位ID}
end

function REQ_SYS_DOUQI_ASK_GET_DQ.setArguments(self,lan_id)
	self.lan_id = lan_id  -- {0 一键拾取| ID 栏位ID}
end

-- {0 一键拾取| ID 栏位ID}
function REQ_SYS_DOUQI_ASK_GET_DQ.setLanId(self, lan_id)
	self.lan_id = lan_id
end
function REQ_SYS_DOUQI_ASK_GET_DQ.getLanId(self)
	return self.lan_id
end
