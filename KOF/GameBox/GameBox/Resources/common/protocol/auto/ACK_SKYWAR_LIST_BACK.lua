
require "common/AcknowledgementMessage"

-- [40532]攻守列表玩家数据 -- 天宫之战 

ACK_SKYWAR_LIST_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_LIST_BACK
	self:init()
end)

function ACK_SKYWAR_LIST_BACK.deserialize(self, reader)
	self.type = reader:readBoolean() -- {true:上阵|false:下阵}
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {玩家名字}
	self.lv = reader:readInt16Unsigned() -- {等级}
	self.camp = reader:readInt8Unsigned() -- {阵营(0:守|1:攻)}
end

-- {true:上阵|false:下阵}
function ACK_SKYWAR_LIST_BACK.getType(self)
	return self.type
end

-- {玩家uid}
function ACK_SKYWAR_LIST_BACK.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_SKYWAR_LIST_BACK.getName(self)
	return self.name
end

-- {等级}
function ACK_SKYWAR_LIST_BACK.getLv(self)
	return self.lv
end

-- {阵营(0:守|1:攻)}
function ACK_SKYWAR_LIST_BACK.getCamp(self)
	return self.camp
end
