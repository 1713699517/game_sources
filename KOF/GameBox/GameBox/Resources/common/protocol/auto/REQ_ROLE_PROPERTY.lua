
require "common/RequestMessage"

-- [1101]请求玩家属性 -- 角色 

REQ_ROLE_PROPERTY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_PROPERTY
	self:init(1 ,{ 1108,1109,700 })
end)

function REQ_ROLE_PROPERTY.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家Uid}
	writer:writeInt16Unsigned(self.type)  -- {0:玩家|伙伴ID}
end

function REQ_ROLE_PROPERTY.setArguments(self,sid,uid,type)
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家Uid}
	self.type = type  -- {0:玩家|伙伴ID}
end

-- {服务器ID}
function REQ_ROLE_PROPERTY.setSid(self, sid)
	self.sid = sid
end
function REQ_ROLE_PROPERTY.getSid(self)
	return self.sid
end

-- {玩家Uid}
function REQ_ROLE_PROPERTY.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_PROPERTY.getUid(self)
	return self.uid
end

-- {0:玩家|伙伴ID}
function REQ_ROLE_PROPERTY.setType(self, type)
	self.type = type
end
function REQ_ROLE_PROPERTY.getType(self)
	return self.type
end
