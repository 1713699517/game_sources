
require "common/AcknowledgementMessage"

-- [37070]DPS排行块 -- 世界BOSS 

ACK_WORLD_BOSS_DPS_XX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_DPS_XX
	self:init()
end)

function ACK_WORLD_BOSS_DPS_XX.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {名字}
	self.rank = reader:readInt16Unsigned() -- {排名}
	self.harm = reader:readInt32Unsigned() -- {伤害}
end

-- {玩家uid}
function ACK_WORLD_BOSS_DPS_XX.getUid(self)
	return self.uid
end

-- {名字}
function ACK_WORLD_BOSS_DPS_XX.getName(self)
	return self.name
end

-- {排名}
function ACK_WORLD_BOSS_DPS_XX.getRank(self)
	return self.rank
end

-- {伤害}
function ACK_WORLD_BOSS_DPS_XX.getHarm(self)
	return self.harm
end
