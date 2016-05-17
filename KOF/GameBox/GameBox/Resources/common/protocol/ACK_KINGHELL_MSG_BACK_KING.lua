
require "common/AcknowledgementMessage"

-- [44630]阎王列表信息块 -- 阎王殿 

ACK_KINGHELL_MSG_BACK_KING = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_MSG_BACK_KING
	self:init()
end)

-- {阎王id}
function ACK_KINGHELL_MSG_BACK_KING.getKingId(self)
	return self.king_id
end

-- {阎王状态,见CONST_KINGHELL_*}
function ACK_KINGHELL_MSG_BACK_KING.getState(self)
	return self.state
end

-- {语言安抚次数}
function ACK_KINGHELL_MSG_BACK_KING.getYyaf(self)
	return self.yyaf
end

-- {礼物安抚次数}
function ACK_KINGHELL_MSG_BACK_KING.getGiftaf(self)
	return self.giftaf
end

-- {判官数量}
function ACK_KINGHELL_MSG_BACK_KING.getMonsCount(self)
	return self.mons_count
end

-- {怪物信息块(46640)}
function ACK_KINGHELL_MSG_BACK_KING.getMonsData(self)
	return self.mons_data
end
