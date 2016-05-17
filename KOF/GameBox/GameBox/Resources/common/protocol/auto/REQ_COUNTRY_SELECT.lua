
require "common/RequestMessage"

-- [14010]选择阵营 -- 阵营 

REQ_COUNTRY_SELECT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_SELECT
	self:init(0, nil)
end)

function REQ_COUNTRY_SELECT.serialize(self, writer)
	writer:writeInt8Unsigned(self.country_id)  -- {阵营类型(见常量),随机则发0}
end

function REQ_COUNTRY_SELECT.setArguments(self,country_id)
	self.country_id = country_id  -- {阵营类型(见常量),随机则发0}
end

-- {阵营类型(见常量),随机则发0}
function REQ_COUNTRY_SELECT.setCountryId(self, country_id)
	self.country_id = country_id
end
function REQ_COUNTRY_SELECT.getCountryId(self)
	return self.country_id
end
