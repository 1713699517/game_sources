
require "common/AcknowledgementMessage"

-- (手动) -- [24880]我的个人排行数据 -- 排行榜 

ACK_TOP_SELF_RANK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_SELF_RANK
	self:init()
end)

function ACK_TOP_SELF_RANK.deserialize(self, reader)
	self.lv = reader:readInt16Unsigned() -- {等级排名}
	self.renown = reader:readInt16Unsigned() -- {声望排名}
	self.gold = reader:readInt16Unsigned() -- {财富排名}
	self.power = reader:readInt16Unsigned() -- {战斗力排名}
	self.charm_sum = reader:readInt16Unsigned() -- {总魅力排名}
	self.charm_mon = reader:readInt16Unsigned() -- {月魅力排名}
	self.charm_day = reader:readInt16Unsigned() -- {日魅力排名}
	self.flower_gift = reader:readInt16Unsigned() -- {送花排名}
	self.flower_recv = reader:readInt16Unsigned() -- {收花排名}
	self.clan_lv = reader:readInt16Unsigned() -- {家族等级排名}
	self.clan_gold = reader:readInt16Unsigned() -- {家族财富排名}
	self.pet = reader:readInt16Unsigned() -- {宠物战斗力排名}
end

-- {等级排名}
function ACK_TOP_SELF_RANK.getLv(self)
	return self.lv
end

-- {声望排名}
function ACK_TOP_SELF_RANK.getRenown(self)
	return self.renown
end

-- {财富排名}
function ACK_TOP_SELF_RANK.getGold(self)
	return self.gold
end

-- {战斗力排名}
function ACK_TOP_SELF_RANK.getPower(self)
	return self.power
end

-- {总魅力排名}
function ACK_TOP_SELF_RANK.getCharmSum(self)
	return self.charm_sum
end

-- {月魅力排名}
function ACK_TOP_SELF_RANK.getCharmMon(self)
	return self.charm_mon
end

-- {日魅力排名}
function ACK_TOP_SELF_RANK.getCharmDay(self)
	return self.charm_day
end

-- {送花排名}
function ACK_TOP_SELF_RANK.getFlowerGift(self)
	return self.flower_gift
end

-- {收花排名}
function ACK_TOP_SELF_RANK.getFlowerRecv(self)
	return self.flower_recv
end

-- {家族等级排名}
function ACK_TOP_SELF_RANK.getClanLv(self)
	return self.clan_lv
end

-- {家族财富排名}
function ACK_TOP_SELF_RANK.getClanGold(self)
	return self.clan_gold
end

-- {宠物战斗力排名}
function ACK_TOP_SELF_RANK.getPet(self)
	return self.pet
end
