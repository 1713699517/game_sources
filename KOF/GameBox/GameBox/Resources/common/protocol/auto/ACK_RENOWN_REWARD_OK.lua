
require "common/AcknowledgementMessage"

-- [22108]领取每日俸禄成功 -- 声望 

ACK_RENOWN_REWARD_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_RENOWN_REWARD_OK
	self:init()
end)

function ACK_RENOWN_REWARD_OK.deserialize(self, reader)
	self.add_money = reader:readInt32Unsigned() -- {增加银元数}
	self.add_star = reader:readInt16Unsigned() -- {增加的星魂数}
end

-- {增加银元数}
function ACK_RENOWN_REWARD_OK.getAddMoney(self)
	return self.add_money
end

-- {增加的星魂数}
function ACK_RENOWN_REWARD_OK.getAddStar(self)
	return self.add_star
end
