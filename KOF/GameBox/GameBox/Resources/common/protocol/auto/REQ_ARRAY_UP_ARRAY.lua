
require "common/RequestMessage"

-- [28020]上阵 -- 布阵 

REQ_ARRAY_UP_ARRAY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARRAY_UP_ARRAY
	self:init(0, nil)
end)

function REQ_ARRAY_UP_ARRAY.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:双击上阵,其它位置索引}
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_ARRAY_UP_ARRAY.setArguments(self,type,partner_id)
	self.type = type  -- {0:双击上阵,其它位置索引}
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {0:双击上阵,其它位置索引}
function REQ_ARRAY_UP_ARRAY.setType(self, type)
	self.type = type
end
function REQ_ARRAY_UP_ARRAY.getType(self)
	return self.type
end

-- {伙伴ID}
function REQ_ARRAY_UP_ARRAY.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_ARRAY_UP_ARRAY.getPartnerId(self)
	return self.partner_id
end
