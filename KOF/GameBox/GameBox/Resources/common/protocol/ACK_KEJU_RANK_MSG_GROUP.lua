
require "common/AcknowledgementMessage"

-- [44555]前十名排行榜 -- 御前科举 

ACK_KEJU_RANK_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KEJU_RANK_MSG_GROUP
	self:init()
end)

-- {玩家ID}
function ACK_KEJU_RANK_MSG_GROUP.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_KEJU_RANK_MSG_GROUP.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_KEJU_RANK_MSG_GROUP.getNameColor(self)
	return self.name_color
end

-- {得分}
function ACK_KEJU_RANK_MSG_GROUP.getScore(self)
	return self.score
end
