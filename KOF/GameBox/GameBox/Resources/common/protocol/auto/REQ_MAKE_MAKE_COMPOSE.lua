
require "common/RequestMessage"

-- [2550] 宝石合成 -- 物品/打造/强化 

REQ_MAKE_MAKE_COMPOSE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_MAKE_COMPOSE
	self:init(1 ,{ 2552,700 })
end)

function REQ_MAKE_MAKE_COMPOSE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {合成方式:1:普通|2:全部}
	writer:writeInt16Unsigned(self.arg)  -- {普通的是idx|全部的是等级}
	writer:writeInt16Unsigned(self.count)  -- {需要合成的数量(一键则为0)}
end

function REQ_MAKE_MAKE_COMPOSE.setArguments(self,type,arg,count)
	self.type = type  -- {合成方式:1:普通|2:全部}
	self.arg = arg  -- {普通的是idx|全部的是等级}
	self.count = count  -- {需要合成的数量(一键则为0)}
end

-- {合成方式:1:普通|2:全部}
function REQ_MAKE_MAKE_COMPOSE.setType(self, type)
	self.type = type
end
function REQ_MAKE_MAKE_COMPOSE.getType(self)
	return self.type
end

-- {普通的是idx|全部的是等级}
function REQ_MAKE_MAKE_COMPOSE.setArg(self, arg)
	self.arg = arg
end
function REQ_MAKE_MAKE_COMPOSE.getArg(self)
	return self.arg
end

-- {需要合成的数量(一键则为0)}
function REQ_MAKE_MAKE_COMPOSE.setCount(self, count)
	self.count = count
end
function REQ_MAKE_MAKE_COMPOSE.getCount(self)
	return self.count
end
