
require "common/RequestMessage"

-- [1269]使用功能 -- 角色 

REQ_ROLE_USE_SYS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_USE_SYS
	self:init(0, nil)
end)

function REQ_ROLE_USE_SYS.serialize(self, writer)
	writer:writeInt16Unsigned(self.sys_id)  -- {功能ID}
end

function REQ_ROLE_USE_SYS.setArguments(self,sys_id)
	self.sys_id = sys_id  -- {功能ID}
end

-- {功能ID}
function REQ_ROLE_USE_SYS.setSysId(self, sys_id)
	self.sys_id = sys_id
end
function REQ_ROLE_USE_SYS.getSysId(self)
	return self.sys_id
end
