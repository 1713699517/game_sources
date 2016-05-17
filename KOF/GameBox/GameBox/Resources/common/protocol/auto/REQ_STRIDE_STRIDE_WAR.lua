
require "common/RequestMessage"

-- [43630]挑战 -- 跨服战 

REQ_STRIDE_STRIDE_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_STRIDE_WAR
	self:init(0, nil)
end)

function REQ_STRIDE_STRIDE_WAR.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:常规模式 2:越级模式}
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID}
end

function REQ_STRIDE_STRIDE_WAR.setArguments(self,type,sid,uid)
	self.type = type  -- {1:常规模式 2:越级模式}
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家UID}
end

-- {1:常规模式 2:越级模式}
function REQ_STRIDE_STRIDE_WAR.setType(self, type)
	self.type = type
end
function REQ_STRIDE_STRIDE_WAR.getType(self)
	return self.type
end

-- {服务器ID}
function REQ_STRIDE_STRIDE_WAR.setSid(self, sid)
	self.sid = sid
end
function REQ_STRIDE_STRIDE_WAR.getSid(self)
	return self.sid
end

-- {玩家UID}
function REQ_STRIDE_STRIDE_WAR.setUid(self, uid)
	self.uid = uid
end
function REQ_STRIDE_STRIDE_WAR.getUid(self)
	return self.uid
end
