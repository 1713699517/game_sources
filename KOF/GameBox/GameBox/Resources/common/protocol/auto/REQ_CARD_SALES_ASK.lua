
require "common/RequestMessage"

-- [24930]请求促销活动可领取状态 -- 新手卡 

REQ_CARD_SALES_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CARD_SALES_ASK
	self:init(1 ,{ 24932,700 })
end)
