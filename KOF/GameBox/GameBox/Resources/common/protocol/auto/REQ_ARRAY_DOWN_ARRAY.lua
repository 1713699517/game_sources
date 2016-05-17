
require "common/RequestMessage"

-- [28030]下阵 -- 布阵 

REQ_ARRAY_DOWN_ARRAY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARRAY_DOWN_ARRAY
	self:init(0, nil)
end)

function REQ_ARRAY_DOWN_ARRAY.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
	writer:writeInt8Unsigned(self.position_idx)  -- {阵位}
end

function REQ_ARRAY_DOWN_ARRAY.setArguments(self,partner_id,position_idx)
	self.partner_id = partner_id  -- {伙伴ID}
	self.position_idx = position_idx  -- {阵位}
end

-- {伙伴ID}
function REQ_ARRAY_DOWN_ARRAY.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_ARRAY_DOWN_ARRAY.getPartnerId(self)
	return self.partner_id
end

-- {阵位}
function REQ_ARRAY_DOWN_ARRAY.setPositionIdx(self, position_idx)
	self.position_idx = position_idx
end
function REQ_ARRAY_DOWN_ARRAY.getPositionIdx(self)
	return self.position_idx
end
