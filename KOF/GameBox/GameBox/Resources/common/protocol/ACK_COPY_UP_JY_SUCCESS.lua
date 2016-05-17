
require "common/AcknowledgementMessage"

-- [7930]挂机-精英副本通关 -- 副本 

ACK_COPY_UP_JY_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_JY_SUCCESS
	self:init()
end)

-- {评价经验}
function ACK_COPY_UP_JY_SUCCESS.getEvaexp(self)
	return self.evaexp
end

-- {评价银元}
function ACK_COPY_UP_JY_SUCCESS.getEvagold(self)
	return self.evagold
end

-- {物品数量}
function ACK_COPY_UP_JY_SUCCESS.getCount(self)
	return self.count
end

-- {挂机物品块(7097)}
function ACK_COPY_UP_JY_SUCCESS.getEvagoodmsg(self)
	return self.evagoodmsg
end
