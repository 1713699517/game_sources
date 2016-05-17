
require "common/AcknowledgementMessage"

-- [21270]开启增益 -- 活动-保卫经书 

ACK_DEFEND_BOOK_START_BUFF = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_START_BUFF
	self:init()
end)

-- {增益类型}
function ACK_DEFEND_BOOK_START_BUFF.getType(self)
	return self.type
end

-- {增益数值}
function ACK_DEFEND_BOOK_START_BUFF.getBuffVal(self)
	return self.buff_val
end

-- {数量}
function ACK_DEFEND_BOOK_START_BUFF.getCount(self)
	return self.count
end

-- {战壕玩家信息块[21180]}
function ACK_DEFEND_BOOK_START_BUFF.getPlayerData(self)
	return self.player_data
end
