
require "common/RequestMessage"

-- (手动) -- [31230]开始酒留仙 -- 客栈 

REQ_INN_DRINK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_DRINK
	self:init()
end)

function REQ_INN_DRINK.serialize(self, writer)
	writer:writeInt8Unsigned(self.arg)  -- {0:银元奉酒 1:金元奉酒}
end

function REQ_INN_DRINK.setArguments(self,arg)
	self.arg = arg  -- {0:银元奉酒 1:金元奉酒}
end

-- {0:银元奉酒 1:金元奉酒}
function REQ_INN_DRINK.setArg(self, arg)
	self.arg = arg
end
function REQ_INN_DRINK.getArg(self)
	return self.arg
end
