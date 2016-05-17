
require "common/AcknowledgementMessage"

-- [14090]阵营事件广播 -- 阵营 

ACK_COUNTRY_EVENT_BROADCAST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_EVENT_BROADCAST
	self:init()
end)

-- {事件类型(见常量)}
function ACK_COUNTRY_EVENT_BROADCAST.getType(self)
	return self.type
end

-- {被杀玩家职位}
function ACK_COUNTRY_EVENT_BROADCAST.getPostKill(self)
	return self.post_kill
end

-- {被杀玩家名字}
function ACK_COUNTRY_EVENT_BROADCAST.getNameKill(self)
	return self.name_kill
end

-- {杀人玩家名字}
function ACK_COUNTRY_EVENT_BROADCAST.getNameKill2(self)
	return self.name_kill2
end

-- {操作人职位}
function ACK_COUNTRY_EVENT_BROADCAST.getPostDeal(self)
	return self.post_deal
end

-- {操作人名字}
function ACK_COUNTRY_EVENT_BROADCAST.getNameDeal(self)
	return self.name_deal
end

-- {被操作人职位}
function ACK_COUNTRY_EVENT_BROADCAST.getPostDeal2(self)
	return self.post_deal2
end

-- {被操作人名字}
function ACK_COUNTRY_EVENT_BROADCAST.getNameDeal2(self)
	return self.name_deal2
end

-- {辞职人职位}
function ACK_COUNTRY_EVENT_BROADCAST.getPostResign(self)
	return self.post_resign
end

-- {辞职人名字}
function ACK_COUNTRY_EVENT_BROADCAST.getNameResign(self)
	return self.name_resign
end

-- {活动开始结束true | false}
function ACK_COUNTRY_EVENT_BROADCAST.getState(self)
	return self.state
end

-- {活动id}
function ACK_COUNTRY_EVENT_BROADCAST.getActivityId(self)
	return self.activity_id
end
