
require "common/RequestMessage"

-- (手动) -- [6080]切磋请求反馈 -- 战斗 

REQ_WAR_COMPARE_RETURN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_COMPARE_RETURN
	self:init()
end)

function REQ_WAR_COMPARE_RETURN.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {请求者Uid}
	writer:writeBoolean(self.rs)  -- {true:同意  false:不同意}
end

function REQ_WAR_COMPARE_RETURN.setArguments(self,uid,rs)
	self.uid = uid  -- {请求者Uid}
	self.rs = rs  -- {true:同意  false:不同意}
end

-- {请求者Uid}
function REQ_WAR_COMPARE_RETURN.setUid(self, uid)
	self.uid = uid
end
function REQ_WAR_COMPARE_RETURN.getUid(self)
	return self.uid
end

-- {true:同意  false:不同意}
function REQ_WAR_COMPARE_RETURN.setRs(self, rs)
	self.rs = rs
end
function REQ_WAR_COMPARE_RETURN.getRs(self)
	return self.rs
end
