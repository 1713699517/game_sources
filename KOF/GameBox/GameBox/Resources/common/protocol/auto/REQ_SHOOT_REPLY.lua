
require "common/RequestMessage"

-- (手动) -- [0]51220 -- 每日一箭 

REQ_SHOOT_REPLY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOOT_REPLY
	self:init()
end)

function REQ_SHOOT_REPLY.serialize(self, writer)
	writer:writeInt16Unsigned(self.freetime)  -- {射箭免费次数}
	writer:writeInt32Unsigned(self.money)  -- {奖池金额}
	writer:writeInt16Unsigned(self.have_get)  -- {已经射中的面板}
end

function REQ_SHOOT_REPLY.setArguments(self,freetime,money,have_get)
	self.freetime = freetime  -- {射箭免费次数}
	self.money = money  -- {奖池金额}
	self.have_get = have_get  -- {已经射中的面板}
end

-- {射箭免费次数}
function REQ_SHOOT_REPLY.setFreetime(self, freetime)
	self.freetime = freetime
end
function REQ_SHOOT_REPLY.getFreetime(self)
	return self.freetime
end

-- {奖池金额}
function REQ_SHOOT_REPLY.setMoney(self, money)
	self.money = money
end
function REQ_SHOOT_REPLY.getMoney(self)
	return self.money
end

-- {已经射中的面板}
function REQ_SHOOT_REPLY.setHaveGet(self, have_get)
	self.have_get = have_get
end
function REQ_SHOOT_REPLY.getHaveGet(self)
	return self.have_get
end
