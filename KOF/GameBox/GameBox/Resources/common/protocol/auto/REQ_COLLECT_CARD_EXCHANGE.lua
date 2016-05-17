
require "common/RequestMessage"

-- [42530]请求兑换卡片套装奖励 -- 收集卡片 

REQ_COLLECT_CARD_EXCHANGE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COLLECT_CARD_EXCHANGE
	self:init(0, nil)
end)

function REQ_COLLECT_CARD_EXCHANGE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:普通|1:金元兑换}
	writer:writeInt16Unsigned(self.id)  -- {卡片套装ID}
end

function REQ_COLLECT_CARD_EXCHANGE.setArguments(self,type,id)
	self.type = type  -- {0:普通|1:金元兑换}
	self.id = id  -- {卡片套装ID}
end

-- {0:普通|1:金元兑换}
function REQ_COLLECT_CARD_EXCHANGE.setType(self, type)
	self.type = type
end
function REQ_COLLECT_CARD_EXCHANGE.getType(self)
	return self.type
end

-- {卡片套装ID}
function REQ_COLLECT_CARD_EXCHANGE.setId(self, id)
	self.id = id
end
function REQ_COLLECT_CARD_EXCHANGE.getId(self)
	return self.id
end
