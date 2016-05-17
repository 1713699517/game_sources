
require "common/AcknowledgementMessage"

-- [40030]是否领取信息块 -- 签到 

ACK_SIGN_REWARD_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SIGN_REWARD_INFO
	self:init()
end)

function ACK_SIGN_REWARD_INFO.deserialize(self, reader)
	self.day = reader:readInt16Unsigned() -- {第几天}
	self.is_get = reader:readInt8Unsigned() -- {是否已经领取（0:未领取;1:已经领取）}
end

-- {第几天}
function ACK_SIGN_REWARD_INFO.getDay(self)
	return self.day
end

-- {是否已经领取（0:未领取;1:已经领取）}
function ACK_SIGN_REWARD_INFO.getIsGet(self)
	return self.is_get
end
