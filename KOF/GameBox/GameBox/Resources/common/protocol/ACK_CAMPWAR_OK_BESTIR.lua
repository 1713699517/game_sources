
require "common/AcknowledgementMessage"

-- [45690]请求振奋成功 -- 活动-阵营战 

ACK_CAMPWAR_OK_BESTIR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_OK_BESTIR
	self:init()
end)

-- {已振奋次数}
function ACK_CAMPWAR_OK_BESTIR.getNum(self)
	return self.num
end

-- {下次振奋需花费金元数}
function ACK_CAMPWAR_OK_BESTIR.getGold(self)
	return self.gold
end

-- {数量}
function ACK_CAMPWAR_OK_BESTIR.getCount(self)
	return self.count
end

-- {属性加成信息块【45695】}
function ACK_CAMPWAR_OK_BESTIR.getAttrData(self)
	return self.attr_data
end
