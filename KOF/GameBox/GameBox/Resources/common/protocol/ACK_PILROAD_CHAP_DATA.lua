
require "common/AcknowledgementMessage"

-- [39010]当前章节信息 -- 取经之路 

ACK_PILROAD_CHAP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_CHAP_DATA
	self:init()
end)

-- {当前章节}
function ACK_PILROAD_CHAP_DATA.getChap(self)
	return self.chap
end

-- {下一章节 1：可去 | 0：不可去}
function ACK_PILROAD_CHAP_DATA.getNextChap(self)
	return self.next_chap
end

-- {战役数量}
function ACK_PILROAD_CHAP_DATA.getCount(self)
	return self.count
end

-- {战役数据信息块(39015)}
function ACK_PILROAD_CHAP_DATA.getBattleData(self)
	return self.battle_data
end
