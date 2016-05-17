
require "common/RequestMessage"

-- [1121]请求玩家扩展属性(暂无效) -- 角色 

REQ_ROLE_PROPERTY_EXT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_PROPERTY_EXT
	self:init(0, nil)
end)

function REQ_ROLE_PROPERTY_EXT.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID}
end

function REQ_ROLE_PROPERTY_EXT.setArguments(self,sid,uid)
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家UID}
end

-- {服务器ID}
function REQ_ROLE_PROPERTY_EXT.setSid(self, sid)
	self.sid = sid
end
function REQ_ROLE_PROPERTY_EXT.getSid(self)
	return self.sid
end

-- {玩家UID}
function REQ_ROLE_PROPERTY_EXT.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_PROPERTY_EXT.getUid(self)
	return self.uid
end
