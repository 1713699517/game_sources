
require "common/RequestMessage"

-- [18040]请求收获鱼 -- 活动-钓鱼达人 

REQ_FISHING_GET_FISH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FISHING_GET_FISH
	self:init(0, nil)
end)

function REQ_FISHING_GET_FISH.serialize(self, writer)
	writer:writeInt8Unsigned(self.num)  -- {浮漂编号 0::一键收鱼}
end

function REQ_FISHING_GET_FISH.setArguments(self,num)
	self.num = num  -- {浮漂编号 0::一键收鱼}
end

-- {浮漂编号 0::一键收鱼}
function REQ_FISHING_GET_FISH.setNum(self, num)
	self.num = num
end
function REQ_FISHING_GET_FISH.getNum(self)
	return self.num
end
