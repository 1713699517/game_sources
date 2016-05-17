
require "common/AcknowledgementMessage"

-- [34040]寻宝结果_旧 -- 活动-龙宫寻宝 

ACK_DRAGON_OK_START_DRAGON = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DRAGON_OK_START_DRAGON
	self:init()
end)

-- {数量}
function ACK_DRAGON_OK_START_DRAGON.getCount(self)
	return self.count
end

-- {奖励信息块 【2001】}
function ACK_DRAGON_OK_START_DRAGON.getRewards(self)
	return self.rewards
end
