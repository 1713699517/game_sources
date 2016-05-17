
require "common/RequestMessage"

-- (手动) -- [24830]评价信息 -- 排行榜 

REQ_TOP_EVALUATE_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TOP_EVALUATE_DATA
	self:init()
end)

function REQ_TOP_EVALUATE_DATA.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器id}
	writer:writeInt32Unsigned(self.uid)  -- {玩家id}
end

function REQ_TOP_EVALUATE_DATA.setArguments(self,sid,uid)
	self.sid = sid  -- {服务器id}
	self.uid = uid  -- {玩家id}
end

-- {服务器id}
function REQ_TOP_EVALUATE_DATA.setSid(self, sid)
	self.sid = sid
end
function REQ_TOP_EVALUATE_DATA.getSid(self)
	return self.sid
end

-- {玩家id}
function REQ_TOP_EVALUATE_DATA.setUid(self, uid)
	self.uid = uid
end
function REQ_TOP_EVALUATE_DATA.getUid(self)
	return self.uid
end
