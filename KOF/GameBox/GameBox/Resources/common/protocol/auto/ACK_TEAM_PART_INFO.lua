
require "common/AcknowledgementMessage"

-- (手动) -- [3700]布阵伙伴信息块 -- 组队系统 

ACK_TEAM_PART_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_PART_INFO
	self:init()
end)

function ACK_TEAM_PART_INFO.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器ID}
	self.uid = reader:readInt32Unsigned() -- {uid}
	self.type = reader:readInt8Unsigned() -- {1:玩家,2:伙伴}
	self.id = reader:readInt32Unsigned() -- {伙伴ID/玩家UID}
	self.position_idx = reader:readInt8Unsigned() -- {阵位}
	self.lv = reader:readInt16Unsigned() -- {等级}
end

-- {服务器ID}
function ACK_TEAM_PART_INFO.getSid(self)
	return self.sid
end

-- {uid}
function ACK_TEAM_PART_INFO.getUid(self)
	return self.uid
end

-- {1:玩家,2:伙伴}
function ACK_TEAM_PART_INFO.getType(self)
	return self.type
end

-- {伙伴ID/玩家UID}
function ACK_TEAM_PART_INFO.getId(self)
	return self.id
end

-- {阵位}
function ACK_TEAM_PART_INFO.getPositionIdx(self)
	return self.position_idx
end

-- {等级}
function ACK_TEAM_PART_INFO.getLv(self)
	return self.lv
end
