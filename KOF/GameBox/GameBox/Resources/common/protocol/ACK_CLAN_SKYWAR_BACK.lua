
require "common/AcknowledgementMessage"

-- [33492]天宫之战面板数据返回 -- 社团 

ACK_CLAN_SKYWAR_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_SKYWAR_BACK
	self:init()
end)

-- {0:不可进入|1:可进入}
function ACK_CLAN_SKYWAR_BACK.getFlag(self)
	return self.flag
end

-- {排名数量}
function ACK_CLAN_SKYWAR_BACK.getCount(self)
	return self.count
end

-- {33495数据块}
function ACK_CLAN_SKYWAR_BACK.getMsgXxx(self)
	return self.msg_xxx
end

-- {0:守方胜|1:攻方胜}
function ACK_CLAN_SKYWAR_BACK.getWinner(self)
	return self.winner
end

-- {占据皇城社团}
function ACK_CLAN_SKYWAR_BACK.getDefend(self)
	return self.defend
end

-- {上次占据皇城社团}
function ACK_CLAN_SKYWAR_BACK.getDefendLast(self)
	return self.defend_last
end

-- {连续占据天数}
function ACK_CLAN_SKYWAR_BACK.getDays(self)
	return self.days
end
