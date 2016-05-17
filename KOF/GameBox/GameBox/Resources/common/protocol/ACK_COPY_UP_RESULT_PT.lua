
require "common/AcknowledgementMessage"

-- [7910]挂机-普通副本某一轮挂机结果 -- 副本 

ACK_COPY_UP_RESULT_PT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_RESULT_PT
	self:init()
end)

-- {第几轮}
function ACK_COPY_UP_RESULT_PT.getUpIdx(self)
	return self.up_idx
end

-- {战斗次数}
function ACK_COPY_UP_RESULT_PT.getCount(self)
	return self.count
end

-- {挂机返回信息块(7096)}
function ACK_COPY_UP_RESULT_PT.getUpdata(self)
	return self.updata
end

-- {评价经验}
function ACK_COPY_UP_RESULT_PT.getEvaexp(self)
	return self.evaexp
end

-- {评价银元}
function ACK_COPY_UP_RESULT_PT.getEvagold(self)
	return self.evagold
end

-- {物品数量}
function ACK_COPY_UP_RESULT_PT.getCount2(self)
	return self.count2
end

-- {挂机物品块(7097)}
function ACK_COPY_UP_RESULT_PT.getEvagoodmsg(self)
	return self.evagoodmsg
end
