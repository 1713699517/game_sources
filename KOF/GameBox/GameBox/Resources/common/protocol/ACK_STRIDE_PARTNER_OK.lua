
require "common/AcknowledgementMessage"

-- [43610]已招募的橙色伙伴 -- 跨服战 

ACK_STRIDE_PARTNER_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_PARTNER_OK
	self:init()
end)

-- {数量}
function ACK_STRIDE_PARTNER_OK.getCount(self)
	return self.count
end

-- {信息块( 31182)}
function ACK_STRIDE_PARTNER_OK.getData(self)
	return self.data
end
