
require "common/AcknowledgementMessage"

-- [2331]元宵活动数据返回 -- 物品/背包 

ACK_GOODS_LANTERN_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_LANTERN_BACK
	self:init()
end)

-- {汤圆数据2333}
function ACK_GOODS_LANTERN_BACK.getXxx1(self)
	return self.xxx1
end

-- {次数物品日志数量 (循环)}
function ACK_GOODS_LANTERN_BACK.getCountE(self)
	return self.count_e
end

-- {数据块2334}
function ACK_GOODS_LANTERN_BACK.getXxx2(self)
	return self.xxx2
end

-- {可抽奖的12格物品}
function ACK_GOODS_LANTERN_BACK.getCountGoods(self)
	return self.count_goods
end

-- {数据块2335}
function ACK_GOODS_LANTERN_BACK.getXxx3(self)
	return self.xxx3
end
