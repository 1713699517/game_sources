
require "common/RequestMessage"

-- [18010]请求钓鱼界面 -- 活动-钓鱼达人 

REQ_FISHING_ASK_FISHING = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FISHING_ASK_FISHING
	self:init(0, nil)
end)
