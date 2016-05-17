
require "common/RequestMessage"

-- [1060]销毁角色 -- 角色 

REQ_ROLE_DEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_DEL
	self:init(0, nil)
end)

function REQ_ROLE_DEL.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {用户ID}
end

function REQ_ROLE_DEL.setArguments(self,uid)
	self.uid = uid  -- {用户ID}
end

-- {用户ID}
function REQ_ROLE_DEL.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_DEL.getUid(self)
	return self.uid
end
