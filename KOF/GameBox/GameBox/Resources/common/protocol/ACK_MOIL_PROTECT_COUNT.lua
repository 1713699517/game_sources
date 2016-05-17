
require "common/AcknowledgementMessage"

-- [35023]苦工保护时间列表 -- 苦工 

ACK_MOIL_PROTECT_COUNT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PROTECT_COUNT
	self:init()
end)

-- {苦工数量}
function ACK_MOIL_PROTECT_COUNT.getCount(self)
	return self.count
end

-- {信息块35022}
function ACK_MOIL_PROTECT_COUNT.getData(self)
	return self.data
end
