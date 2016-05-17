
require "common/AcknowledgementMessage"

-- (手动) -- [7840]领取副本通关奖励成功 -- 副本 

ACK_COPY_REWARD_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_REWARD_OK
	self:init()
end)
