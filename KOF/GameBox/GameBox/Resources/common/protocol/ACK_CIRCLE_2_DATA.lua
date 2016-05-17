
require "common/AcknowledgementMessage"

-- [36011]当前章节信息(新) -- 三界杀 

ACK_CIRCLE_2_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CIRCLE_2_DATA
	self:init()
end)

-- {当前章节}
function ACK_CIRCLE_2_DATA.getChap(self)
	return self.chap
end

-- {1:可去，0:不可}
function ACK_CIRCLE_2_DATA.getNextChap(self)
	return self.next_chap
end

-- {数量}
function ACK_CIRCLE_2_DATA.getCount(self)
	return self.count
end

-- {36022}
function ACK_CIRCLE_2_DATA.getChapData(self)
	return self.chap_data
end
