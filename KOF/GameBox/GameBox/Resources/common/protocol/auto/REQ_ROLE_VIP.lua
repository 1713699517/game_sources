
require "common/RequestMessage"

-- [1312]请求玩家VIP -- 角色 

REQ_ROLE_VIP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_VIP
	self:init(0, nil)
end)

function REQ_ROLE_VIP.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID}
end

function REQ_ROLE_VIP.setArguments(self,uid)
	self.uid = uid  -- {玩家UID}
end

-- {玩家UID}
function REQ_ROLE_VIP.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_VIP.getUid(self)
	return self.uid
end
