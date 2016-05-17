
require "common/AcknowledgementMessage"

-- [23931]高手信息 -- 封神台 

ACK_ARENA_ACE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_ACE
	self:init()
end)

-- {排名}
function ACK_ARENA_ACE.getRanking(self)
	return self.ranking
end

-- {uid}
function ACK_ARENA_ACE.getUid(self)
	return self.uid
end

-- {名字}
function ACK_ARENA_ACE.getName(self)
	return self.name
end

-- {等级}
function ACK_ARENA_ACE.getLv(self)
	return self.lv
end

-- {趋势}
function ACK_ARENA_ACE.getTrend(self)
	return self.trend
end

-- {家族名字}
function ACK_ARENA_ACE.getClanName(self)
    return self.clan_name
end
