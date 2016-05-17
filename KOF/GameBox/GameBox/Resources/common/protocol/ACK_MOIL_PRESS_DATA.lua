
require "common/AcknowledgementMessage"

-- [35061]可压榨苦工 -- 苦工 

ACK_MOIL_PRESS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PRESS_DATA
	self:init()
end)

-- {3:互动4:压榨}
function ACK_MOIL_PRESS_DATA.getType(self)
	return self.type
end

-- {数量}
function ACK_MOIL_PRESS_DATA.getCount(self)
	return self.count
end

-- {苦工信息}
function ACK_MOIL_PRESS_DATA.getMoilData(self)
	return self.moil_data
end
