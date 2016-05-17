
require "common/AcknowledgementMessage"

-- [43550]三界争霸/巅峰之战排行榜 -- 跨服战 

ACK_STRIDE_RANK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_RANK_DATA
	self:init()
end)

-- {1:挑战信息2:三界榜3:巅峰榜4:巅峰之战挑战信息5:18位挑战榜信息6:越级挑战信息}
function ACK_STRIDE_RANK_DATA.getType(self)
	return self.type
end

-- {数量}
function ACK_STRIDE_RANK_DATA.getCount(self)
	return self.count
end

-- {信息块(43551)}
function ACK_STRIDE_RANK_DATA.getData(self)
	return self.data
end
