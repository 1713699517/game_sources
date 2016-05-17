
require "common/RequestMessage"

-- [3510]请求队伍面板 -- 组队系统 

REQ_TEAM_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_REQUEST
	self:init(0 ,{ 3520,700 })
end)

function REQ_TEAM_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {详见：CONST_COPY_TYPE_*}
end

function REQ_TEAM_REQUEST.setArguments(self,type)
	self.type = type  -- {详见：CONST_COPY_TYPE_*}
end

-- {详见：CONST_COPY_TYPE_*}
function REQ_TEAM_REQUEST.setType(self, type)
	self.type = type
end
function REQ_TEAM_REQUEST.getType(self)
	return self.type
end
