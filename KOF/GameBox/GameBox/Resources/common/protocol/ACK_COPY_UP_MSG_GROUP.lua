
require "common/AcknowledgementMessage"

-- [7940]挂机返回信息块 -- 副本 

ACK_COPY_UP_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_MSG_GROUP
	self:init()
end)

-- {第几次战斗}
function ACK_COPY_UP_MSG_GROUP.getTimes(self)
	return self.times
end

-- {经验}
function ACK_COPY_UP_MSG_GROUP.getExp(self)
	return self.exp
end

-- {银元}
function ACK_COPY_UP_MSG_GROUP.getGold(self)
	return self.gold
end

-- {物品数量}
function ACK_COPY_UP_MSG_GROUP.getCount(self)
	return self.count
end

-- {挂机物品块(7097)}
function ACK_COPY_UP_MSG_GROUP.getGoodmsg(self)
	return self.goodmsg
end
