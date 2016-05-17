
require "common/RequestMessage"

-- [53250]领取奖励 -- 新手特权 

REQ_PRIVILEGE_GET_REWARDS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PRIVILEGE_GET_REWARDS
	self:init(0, nil)
end)
