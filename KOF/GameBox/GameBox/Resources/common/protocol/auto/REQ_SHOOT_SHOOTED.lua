
require "common/RequestMessage"

-- [51250]请求射箭 -- 每日一箭 

REQ_SHOOT_SHOOTED = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOOT_SHOOTED
	self:init(1 ,{ 700 })
end)

function REQ_SHOOT_SHOOTED.serialize(self, writer)
	writer:writeInt16Unsigned(self.position)  -- {被射中的位置}
end

function REQ_SHOOT_SHOOTED.setArguments(self,position)
	self.position = position  -- {被射中的位置}
end

-- {被射中的位置}
function REQ_SHOOT_SHOOTED.setPosition(self, position)
	self.position = position
end
function REQ_SHOOT_SHOOTED.getPosition(self)
	return self.position
end
