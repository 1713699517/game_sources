
require "common/RequestMessage"

-- [22107]领取每日俸禄 -- 声望 

REQ_RENOWN_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_RENOWN_REWARD
	self:init(0, nil)
end)
