
require "common/RequestMessage"

-- [18040]请求收获鱼 -- 活动-钓鱼达人 


REQ_FISHING_GET_FISH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FISHING_GET_FISH
	self:init()
end)

function REQ_FISHING_GET_FISH.serialize(self, writer)
	writer:writeInt8Unsigned(self.num)
end

function REQ_FISHING_GET_FISH.setArguments(self,num)
	self.num = num
end

function REQ_FISHING_GET_FISH.getnum(self, value)
	return self.num
end
