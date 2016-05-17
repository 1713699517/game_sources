
require "common/RequestMessage"

-- [14030]阵营排名 -- 阵营 

REQ_COUNTRY_RANK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_RANK
	self:init(0, nil)
end)

function REQ_COUNTRY_RANK.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {阵营排名类型(见常量)}
end

function REQ_COUNTRY_RANK.setArguments(self,type)
	self.type = type  -- {阵营排名类型(见常量)}
end

-- {阵营排名类型(见常量)}
function REQ_COUNTRY_RANK.setType(self, type)
	self.type = type
end
function REQ_COUNTRY_RANK.getType(self)
	return self.type
end
