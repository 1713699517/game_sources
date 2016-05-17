
require "common/RequestMessage"

-- [40010]请求登陆奖励页面 -- 签到 

REQ_SIGN_REQUES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SIGN_REQUES
	self:init(1 ,{ 40030,40020,700 })
end)
