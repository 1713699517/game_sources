
require "common/AcknowledgementMessage"

-- [40560]帮派积分数据 -- 天宫之战 

ACK_SKYWAR_SCORE_CLAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_SCORE_CLAN
	self:init()
end)

function ACK_SKYWAR_SCORE_CLAN.deserialize(self, reader)
	self.clan_id = reader:readInt32Unsigned() -- {帮派ID}
	self.clan_name = reader:readString() -- {帮派名字}
	self.rank = reader:readInt16Unsigned() -- {排名}
	self.score = reader:readInt32Unsigned() -- {积分}
end

-- {帮派ID}
function ACK_SKYWAR_SCORE_CLAN.getClanId(self)
	return self.clan_id
end

-- {帮派名字}
function ACK_SKYWAR_SCORE_CLAN.getClanName(self)
	return self.clan_name
end

-- {排名}
function ACK_SKYWAR_SCORE_CLAN.getRank(self)
	return self.rank
end

-- {积分}
function ACK_SKYWAR_SCORE_CLAN.getScore(self)
	return self.score
end
