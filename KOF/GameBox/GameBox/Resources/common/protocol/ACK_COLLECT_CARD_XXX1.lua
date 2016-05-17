
require "common/AcknowledgementMessage"

-- [42524]套装数据信息块 -- 收集卡片 

ACK_COLLECT_CARD_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COLLECT_CARD_XXX1
	self:init()
end)

-- {卡片套装ID}
function ACK_COLLECT_CARD_XXX1.getId(self)
	return self.id
end

-- {卡片数量}
function ACK_COLLECT_CARD_XXX1.getCount1(self)
	return self.count1
end

-- {需要卡片数据块42526}
function ACK_COLLECT_CARD_XXX1.getMsgXxx1(self)
	return self.msg_xxx1
end

-- {奖励虚拟货币数量}
function ACK_COLLECT_CARD_XXX1.getCount2(self)
	return self.count2
end

-- {虚拟货币信息块42528}
function ACK_COLLECT_CARD_XXX1.getMsgXxx2(self)
	return self.msg_xxx2
end

-- {奖励物品数量}
function ACK_COLLECT_CARD_XXX1.getCount3(self)
	return self.count3
end

-- {奖励物品信息块42526}
function ACK_COLLECT_CARD_XXX1.getMsgXxx3(self)
	return self.msg_xxx3
end
