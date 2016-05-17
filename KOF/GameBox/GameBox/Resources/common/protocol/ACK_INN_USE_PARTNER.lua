
require "common/AcknowledgementMessage"

-- [31180]返回已经供奉的伙伴列表 -- 客栈 

ACK_INN_USE_PARTNER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_USE_PARTNER
	self:init()
end)

-- {数量}
function ACK_INN_USE_PARTNER.getCount(self)
	return self.count
end

-- {31182}
function ACK_INN_USE_PARTNER.getPartnerdata(self)
	return self.partnerdata
end
