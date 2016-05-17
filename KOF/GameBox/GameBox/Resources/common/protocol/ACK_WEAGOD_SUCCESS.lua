
require "common/AcknowledgementMessage"

-- [32060]招财成功返回 -- 财神 

ACK_WEAGOD_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_SUCCESS
	self:init()
end)

function ACK_WEAGOD_SUCCESS.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {返回类型（1：单次招财；2：批量招财）}
end

-- {返回类型（1：单次招财；2：批量招财）}
function ACK_WEAGOD_SUCCESS.getType(self)
	return self.type
end
