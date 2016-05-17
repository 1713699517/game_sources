
require "common/RequestMessage"

-- [50280]领取奖励 -- 风林山火 

REQ_FLSH_GET_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FLSH_GET_REWARD
	self:init(0 ,{ 50290,700 })
end)
