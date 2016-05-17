
require "common/RequestMessage"

-- [34520]请求积分数据 -- 商城 

REQ_SHOP_ASK_INTEGRAL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOP_ASK_INTEGRAL
	self:init(0, nil)
end)
