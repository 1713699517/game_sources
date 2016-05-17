
require "common/AcknowledgementMessage"

-- [31121]伙伴信息块 -- 客栈 

ACK_INN_H_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_H_DATA
	self:init()
end)

function ACK_INN_H_DATA.deserialize(self, reader)
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
	self.stata = reader:readInt8Unsigned() -- {状态（CONST_INN_STATA）}
	self.lv = reader:readInt8Unsigned() -- {伙伴当前等级}
end

-- {伙伴ID}
function ACK_INN_H_DATA.getPartnerId(self)
	return self.partner_id
end

-- {状态（CONST_INN_STATA）}
function ACK_INN_H_DATA.getStata(self)
	return self.stata
end

-- {伙伴当前等级}
function ACK_INN_H_DATA.getLv(self)
	return self.lv
end
