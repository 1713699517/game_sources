
require "common/AcknowledgementMessage"

-- [14027]改变阵营返回 -- 阵营 

ACK_COUNTRY_CHANGE_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_CHANGE_RESULT
	self:init()
end)

function ACK_COUNTRY_CHANGE_RESULT.deserialize(self, reader)
	self.country_id_old = reader:readInt8Unsigned() -- {旧阵营类型(见常量)}
	self.country_id_new = reader:readInt8Unsigned() -- {新阵营类型(见常量)}
end

-- {旧阵营类型(见常量)}
function ACK_COUNTRY_CHANGE_RESULT.getCountryIdOld(self)
	return self.country_id_old
end

-- {新阵营类型(见常量)}
function ACK_COUNTRY_CHANGE_RESULT.getCountryIdNew(self)
	return self.country_id_new
end
