
require "common/RequestMessage"

-- [3540]请求通关的副本 -- 组队系统 

REQ_TEAM_PASS_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_PASS_REQUEST
	self:init(0 ,{ 3550,700 })
end)

function REQ_TEAM_PASS_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {详见：CONST_COPY_TYPE_*}
end

function REQ_TEAM_PASS_REQUEST.setArguments(self,type)
	self.type = type  -- {详见：CONST_COPY_TYPE_*}
end

-- {详见：CONST_COPY_TYPE_*}
function REQ_TEAM_PASS_REQUEST.setType(self, type)
	self.type = type
end
function REQ_TEAM_PASS_REQUEST.getType(self)
	return self.type
end
