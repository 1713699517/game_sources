
require "common/AcknowledgementMessage"

-- [31140]返回培养信息 -- 客栈 

ACK_INN_CULTURE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_CULTURE_DATA
	self:init()
end)

function ACK_INN_CULTURE_DATA.deserialize(self, reader)
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
	self. shinwakan = reader:readXXXGroup() -- {当前友好度}
end

-- {伙伴ID}
function ACK_INN_CULTURE_DATA.getPartnerId(self)
	return self.partner_id
end

-- {当前友好度}
function ACK_INN_CULTURE_DATA.getShinwakan(self)
	return self. shinwakan
end
