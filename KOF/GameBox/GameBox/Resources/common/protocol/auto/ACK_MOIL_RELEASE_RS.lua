
require "common/AcknowledgementMessage"

-- [35110]结果 -- 苦工 

ACK_MOIL_RELEASE_RS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_RELEASE_RS
	self:init()
end)

function ACK_MOIL_RELEASE_RS.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {身份ID}
end

-- {身份ID}
function ACK_MOIL_RELEASE_RS.getType(self)
	return self.type
end
