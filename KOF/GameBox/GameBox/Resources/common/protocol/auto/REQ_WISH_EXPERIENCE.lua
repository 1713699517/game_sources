
require "common/RequestMessage"

-- [10020]领取祝福经验 -- 祝福 

REQ_WISH_EXPERIENCE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WISH_EXPERIENCE
	self:init(0, nil)
end)

function REQ_WISH_EXPERIENCE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {(1:一倍)(2:双倍)}
end

function REQ_WISH_EXPERIENCE.setArguments(self,type)
	self.type = type  -- {(1:一倍)(2:双倍)}
end

-- {(1:一倍)(2:双倍)}
function REQ_WISH_EXPERIENCE.setType(self, type)
	self.type = type
end
function REQ_WISH_EXPERIENCE.getType(self)
	return self.type
end
