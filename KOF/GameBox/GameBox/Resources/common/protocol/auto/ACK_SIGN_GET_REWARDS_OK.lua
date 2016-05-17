
require "common/AcknowledgementMessage"

-- [40050]返回领取奖励信息 -- 签到 

ACK_SIGN_GET_REWARDS_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SIGN_GET_REWARDS_OK
	self:init()
end)

function ACK_SIGN_GET_REWARDS_OK.deserialize(self, reader)
	self.day = reader:readInt16Unsigned() -- {领取第几天的奖励成功}
end

-- {领取第几天的奖励成功}
function ACK_SIGN_GET_REWARDS_OK.getDay(self)
	return self.day
end
