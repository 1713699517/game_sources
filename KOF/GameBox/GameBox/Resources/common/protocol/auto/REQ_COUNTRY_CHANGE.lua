
require "common/RequestMessage"

-- [14025]改变阵营 -- 阵营 

REQ_COUNTRY_CHANGE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_CHANGE
	self:init(0, nil)
end)

function REQ_COUNTRY_CHANGE.serialize(self, writer)
	writer:writeInt8Unsigned(self.country_id)  -- {阵营类型(见常量)}
end

function REQ_COUNTRY_CHANGE.setArguments(self,country_id)
	self.country_id = country_id  -- {阵营类型(见常量)}
end

-- {阵营类型(见常量)}
function REQ_COUNTRY_CHANGE.setCountryId(self, country_id)
	self.country_id = country_id
end
function REQ_COUNTRY_CHANGE.getCountryId(self)
	return self.country_id
end
