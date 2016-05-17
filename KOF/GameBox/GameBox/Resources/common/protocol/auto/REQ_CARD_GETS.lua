
require "common/RequestMessage"

-- [24910]领取卡 -- 新手卡 

REQ_CARD_GETS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CARD_GETS
	self:init(1 ,{ 24920,700 })
end)

function REQ_CARD_GETS.serialize(self, writer)
	writer:writeString(self.ids)  -- {卡号}
end

function REQ_CARD_GETS.setArguments(self,ids)
	self.ids = ids  -- {卡号}
end

-- {卡号}
function REQ_CARD_GETS.setIds(self, ids)
	self.ids = ids
end
function REQ_CARD_GETS.getIds(self)
	return self.ids
end
