
require "common/RequestMessage"

-- [2225]请求容器扩充 -- 物品/背包 

REQ_GOODS_ENLARGE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_ENLARGE_REQUEST
	self:init(1 ,{ 2227,2230,700 })
end)

function REQ_GOODS_ENLARGE_REQUEST.serialize(self, writer)
	writer:writeBoolean(self.arg)  -- {true:确认|false:询问消耗数量}
end

function REQ_GOODS_ENLARGE_REQUEST.setArguments(self,arg)
	self.arg = arg  -- {true:确认|false:询问消耗数量}
end

-- {true:确认|false:询问消耗数量}
function REQ_GOODS_ENLARGE_REQUEST.setArg(self, arg)
	self.arg = arg
end
function REQ_GOODS_ENLARGE_REQUEST.getArg(self)
	return self.arg
end
