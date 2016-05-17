
require "common/AcknowledgementMessage"

-- [33495]天宫之战排行数据块 -- 社团 

ACK_CLAN_SKYWAR_RANK_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_SKYWAR_RANK_XXX
	self:init()
end)

-- {排名}
function ACK_CLAN_SKYWAR_RANK_XXX.getRank(self)
	return self.rank
end

-- {社团名字}
function ACK_CLAN_SKYWAR_RANK_XXX.getClanName(self)
	return self.clan_name
end

-- {积分}
function ACK_CLAN_SKYWAR_RANK_XXX.getScore(self)
	return self.score
end
