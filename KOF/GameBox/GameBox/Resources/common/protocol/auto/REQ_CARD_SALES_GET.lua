
require "common/RequestMessage"

-- [24940]请求领取奖励 -- 新手卡 

REQ_CARD_SALES_GET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CARD_SALES_GET
	self:init(1 ,{ 24950,700 })
end)

function REQ_CARD_SALES_GET.serialize(self, writer)
	writer:writeInt16Unsigned(self.id)  -- {活动ID}
	writer:writeInt16Unsigned(self.id_step)  -- {活动阶段}
end

function REQ_CARD_SALES_GET.setArguments(self,id,id_step)
	self.id = id  -- {活动ID}
	self.id_step = id_step  -- {活动阶段}
end

-- {活动ID}
function REQ_CARD_SALES_GET.setId(self, id)
	self.id = id
end
function REQ_CARD_SALES_GET.getId(self)
	return self.id
end

-- {活动阶段}
function REQ_CARD_SALES_GET.setIdStep(self, id_step)
	self.id_step = id_step
end
function REQ_CARD_SALES_GET.getIdStep(self)
	return self.id_step
end
