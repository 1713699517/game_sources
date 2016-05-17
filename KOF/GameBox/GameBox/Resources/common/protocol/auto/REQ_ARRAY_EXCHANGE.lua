
require "common/RequestMessage"

-- [28040]交换阵位 -- 布阵 

REQ_ARRAY_EXCHANGE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARRAY_EXCHANGE
	self:init(0, nil)
end)

function REQ_ARRAY_EXCHANGE.serialize(self, writer)
	writer:writeInt8Unsigned(self.fpartner_idx)  -- {交换伙伴索引}
	writer:writeInt16Unsigned(self.partner_idx)  -- {被交换伙伴索引}
end

function REQ_ARRAY_EXCHANGE.setArguments(self,fpartner_idx,partner_idx)
	self.fpartner_idx = fpartner_idx  -- {交换伙伴索引}
	self.partner_idx = partner_idx  -- {被交换伙伴索引}
end

-- {交换伙伴索引}
function REQ_ARRAY_EXCHANGE.setFpartnerIdx(self, fpartner_idx)
	self.fpartner_idx = fpartner_idx
end
function REQ_ARRAY_EXCHANGE.getFpartnerIdx(self)
	return self.fpartner_idx
end

-- {被交换伙伴索引}
function REQ_ARRAY_EXCHANGE.setPartnerIdx(self, partner_idx)
	self.partner_idx = partner_idx
end
function REQ_ARRAY_EXCHANGE.getPartnerIdx(self)
	return self.partner_idx
end
