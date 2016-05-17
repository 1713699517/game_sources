
require "common/RequestMessage"

-- (手动) -- [3705]伙伴上阵 -- 组队系统 

REQ_TEAM_UP_ARRAY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_UP_ARRAY
	self:init()
end)

function REQ_TEAM_UP_ARRAY.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家Uid}
	writer:writeInt8Unsigned(self.type)  -- {0:双击上阵,其它位置:索引}
	writer:writeInt32Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_TEAM_UP_ARRAY.setArguments(self,sid,uid,type,partner_id)
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家Uid}
	self.type = type  -- {0:双击上阵,其它位置:索引}
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {服务器ID}
function REQ_TEAM_UP_ARRAY.setSid(self, sid)
	self.sid = sid
end
function REQ_TEAM_UP_ARRAY.getSid(self)
	return self.sid
end

-- {玩家Uid}
function REQ_TEAM_UP_ARRAY.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_UP_ARRAY.getUid(self)
	return self.uid
end

-- {0:双击上阵,其它位置:索引}
function REQ_TEAM_UP_ARRAY.setType(self, type)
	self.type = type
end
function REQ_TEAM_UP_ARRAY.getType(self)
	return self.type
end

-- {伙伴ID}
function REQ_TEAM_UP_ARRAY.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_TEAM_UP_ARRAY.getPartnerId(self)
	return self.partner_id
end
