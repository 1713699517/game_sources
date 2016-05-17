
require "common/RequestMessage"

-- (手动) -- [3710]伙伴下阵 -- 组队系统 

REQ_TEAM_DOWN_ARRAY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_DOWN_ARRAY
	self:init()
end)

function REQ_TEAM_DOWN_ARRAY.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家Uid}
	writer:writeInt32Unsigned(self.partner_id)  -- {伙伴ID}
	writer:writeInt8Unsigned(self.position_idx)  -- {阵位}
end

function REQ_TEAM_DOWN_ARRAY.setArguments(self,sid,uid,partner_id,position_idx)
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家Uid}
	self.partner_id = partner_id  -- {伙伴ID}
	self.position_idx = position_idx  -- {阵位}
end

-- {服务器ID}
function REQ_TEAM_DOWN_ARRAY.setSid(self, sid)
	self.sid = sid
end
function REQ_TEAM_DOWN_ARRAY.getSid(self)
	return self.sid
end

-- {玩家Uid}
function REQ_TEAM_DOWN_ARRAY.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_DOWN_ARRAY.getUid(self)
	return self.uid
end

-- {伙伴ID}
function REQ_TEAM_DOWN_ARRAY.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_TEAM_DOWN_ARRAY.getPartnerId(self)
	return self.partner_id
end

-- {阵位}
function REQ_TEAM_DOWN_ARRAY.setPositionIdx(self, position_idx)
	self.position_idx = position_idx
end
function REQ_TEAM_DOWN_ARRAY.getPositionIdx(self)
	return self.position_idx
end
