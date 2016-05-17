
require "common/RequestMessage"

-- [56810]勾选功能 -- 系统设置 

REQ_SYS_SET_CHECK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_SET_CHECK
	self:init(0, nil)
end)

function REQ_SYS_SET_CHECK.serialize(self, writer)
	writer:writeInt16Unsigned(self.type)  -- {功能Id}
end

function REQ_SYS_SET_CHECK.setArguments(self,type)
	self.type = type  -- {功能Id}
end

-- {功能Id}
function REQ_SYS_SET_CHECK.setType(self, type)
	self.type = type
end
function REQ_SYS_SET_CHECK.getType(self)
	return self.type
end
