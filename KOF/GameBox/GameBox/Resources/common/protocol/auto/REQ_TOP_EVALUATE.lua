
require "common/RequestMessage"

-- (手动) -- [24810]评价 -- 排行榜 

REQ_TOP_EVALUATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TOP_EVALUATE
	self:init()
end)

function REQ_TOP_EVALUATE.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器id}
	writer:writeInt32Unsigned(self.uid)  -- {玩家id}
	writer:writeInt8Unsigned(self.type)  -- {评价类型(0:鄙视 1:崇拜)}
end

function REQ_TOP_EVALUATE.setArguments(self,sid,uid,type)
	self.sid = sid  -- {服务器id}
	self.uid = uid  -- {玩家id}
	self.type = type  -- {评价类型(0:鄙视 1:崇拜)}
end

-- {服务器id}
function REQ_TOP_EVALUATE.setSid(self, sid)
	self.sid = sid
end
function REQ_TOP_EVALUATE.getSid(self)
	return self.sid
end

-- {玩家id}
function REQ_TOP_EVALUATE.setUid(self, uid)
	self.uid = uid
end
function REQ_TOP_EVALUATE.getUid(self)
	return self.uid
end

-- {评价类型(0:鄙视 1:崇拜)}
function REQ_TOP_EVALUATE.setType(self, type)
	self.type = type
end
function REQ_TOP_EVALUATE.getType(self)
	return self.type
end
