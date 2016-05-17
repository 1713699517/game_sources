
require "common/RequestMessage"

-- [42540]请求兑换所需金元 -- 收集卡片 

REQ_COLLECT_CARD_EXCHANGE_COST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COLLECT_CARD_EXCHANGE_COST
	self:init(0, nil)
end)

function REQ_COLLECT_CARD_EXCHANGE_COST.serialize(self, writer)
	writer:writeInt16Unsigned(self.id	)  -- {卡片套装ID}
end

function REQ_COLLECT_CARD_EXCHANGE_COST.setArguments(self,id	)
	self.id	 = id	  -- {卡片套装ID}
end

-- {卡片套装ID}
function REQ_COLLECT_CARD_EXCHANGE_COST.setId	(self, id	)
	self.id	 = id	
end
function REQ_COLLECT_CARD_EXCHANGE_COST.getId	(self)
	return self.id	
end
