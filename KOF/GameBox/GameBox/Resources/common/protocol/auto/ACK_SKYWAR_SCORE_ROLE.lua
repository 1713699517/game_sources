
require "common/AcknowledgementMessage"

-- [40562]个人积分数据 -- 天宫之战 

ACK_SKYWAR_SCORE_ROLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_SCORE_ROLE
	self:init()
end)

function ACK_SKYWAR_SCORE_ROLE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {玩家名字}
	self.lv = reader:readInt16Unsigned() -- {玩家等级}
	self.kill = reader:readInt16Unsigned() -- {总击杀数}
	self.score = reader:readInt32Unsigned() -- {积分}
end

-- {玩家uid}
function ACK_SKYWAR_SCORE_ROLE.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_SKYWAR_SCORE_ROLE.getName(self)
	return self.name
end

-- {玩家等级}
function ACK_SKYWAR_SCORE_ROLE.getLv(self)
	return self.lv
end

-- {总击杀数}
function ACK_SKYWAR_SCORE_ROLE.getKill(self)
	return self.kill
end

-- {积分}
function ACK_SKYWAR_SCORE_ROLE.getScore(self)
	return self.score
end
