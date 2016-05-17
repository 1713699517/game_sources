
require "common/RequestMessage"

-- (手动) -- [6060]请求切磋 -- 战斗 

REQ_WAR_COMPARE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_COMPARE_REQUEST
	self:init()
end)

function REQ_WAR_COMPARE_REQUEST.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {被请求玩家Uid}
end

function REQ_WAR_COMPARE_REQUEST.setArguments(self,uid)
	self.uid = uid  -- {被请求玩家Uid}
end

-- {被请求玩家Uid}
function REQ_WAR_COMPARE_REQUEST.setUid(self, uid)
	self.uid = uid
end
function REQ_WAR_COMPARE_REQUEST.getUid(self)
	return self.uid
end
