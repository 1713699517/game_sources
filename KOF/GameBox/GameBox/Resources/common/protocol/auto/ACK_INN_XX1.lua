
require "common/AcknowledgementMessage"

-- (手动) -- [31182]partner_data -- 客栈 

ACK_INN_XX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_XX1
	self:init()
end)

function ACK_INN_XX1.deserialize(self, reader)
	self.use = reader:readInt8Unsigned() -- {0:已招募 1:出站 2:休息中}
	self.partner_id = reader:readInt16Unsigned() -- {	伙伴ID}
	self.fairy = reader:readInt32Unsigned() -- {已经供奉的仙缘点}
end

-- {0:已招募 1:出站 2:休息中}
function ACK_INN_XX1.getUse(self)
	return self.use
end

-- {	伙伴ID}
function ACK_INN_XX1.getPartnerId(self)
	return self.partner_id
end

-- {已经供奉的仙缘点}
function ACK_INN_XX1.getFairy(self)
	return self.fairy
end
