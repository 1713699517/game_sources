
require "common/AcknowledgementMessage"

-- [2332]次数物品数据返回 -- 物品/背包 

ACK_GOODS_TIMES_GOODS_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_TIMES_GOODS_BACK
	self:init()
end)

-- {次数物品数据数量}
function ACK_GOODS_TIMES_GOODS_BACK.getCountG(self)
	return self.count_g
end

-- {数据块2333}
function ACK_GOODS_TIMES_GOODS_BACK.getXxx1(self)
	return self.xxx1
end

-- {次数物品日志数量}
function ACK_GOODS_TIMES_GOODS_BACK.getCountE(self)
	return self.count_e
end

-- {数据块2334}
function ACK_GOODS_TIMES_GOODS_BACK.getXxx2(self)
	return self.xxx2
end
