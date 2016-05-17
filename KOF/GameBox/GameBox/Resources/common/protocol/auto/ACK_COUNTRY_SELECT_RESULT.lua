
require "common/AcknowledgementMessage"

-- [14015]选择阵营结果 -- 阵营 

ACK_COUNTRY_SELECT_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_SELECT_RESULT
	self:init()
end)

function ACK_COUNTRY_SELECT_RESULT.deserialize(self, reader)
	self.country_id = reader:readInt8Unsigned() -- {阵营类型(见常量)}
end

-- {阵营类型(见常量)}
function ACK_COUNTRY_SELECT_RESULT.getCountryId(self)
	return self.country_id
end
