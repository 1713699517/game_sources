
require "common/RequestMessage"

-- [34510] 请求店铺面板 -- 商城 

REQ_SHOP_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOP_REQUEST
	self:init(1 ,{ 34511,34512,700 })
end)

function REQ_SHOP_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.type)  -- {店铺类型}
	writer:writeInt16Unsigned(self.type_bb)  -- {子店铺类型}
end

function REQ_SHOP_REQUEST.setArguments(self,type,type_bb)
	self.type = type  -- {店铺类型}
	self.type_bb = type_bb  -- {子店铺类型}
end

-- {店铺类型}
function REQ_SHOP_REQUEST.setType(self, type)
	self.type = type
end
function REQ_SHOP_REQUEST.getType(self)
	return self.type
end

-- {子店铺类型}
function REQ_SHOP_REQUEST.setTypeBb(self, type_bb)
	self.type_bb = type_bb
end
function REQ_SHOP_REQUEST.getTypeBb(self)
	return self.type_bb
end
