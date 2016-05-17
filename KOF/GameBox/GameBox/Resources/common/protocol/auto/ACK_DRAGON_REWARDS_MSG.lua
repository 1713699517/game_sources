
require "common/AcknowledgementMessage"

-- [34050]寻宝奖励信息块 -- 活动-龙宫寻宝 

ACK_DRAGON_REWARDS_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DRAGON_REWARDS_MSG
	self:init()
end)

function ACK_DRAGON_REWARDS_MSG.deserialize(self, reader)
	self.good_id = reader:readInt32Unsigned() -- {物品ID}
	self.count = reader:readInt8Unsigned() -- {物品数量}
end

-- {物品ID}
function ACK_DRAGON_REWARDS_MSG.getGoodId(self)
	return self.good_id
end

-- {物品数量}
function ACK_DRAGON_REWARDS_MSG.getCount(self)
	return self.count
end
