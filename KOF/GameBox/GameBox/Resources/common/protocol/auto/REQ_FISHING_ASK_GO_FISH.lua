
require "common/RequestMessage"

-- [18020]请求开始钓鱼 -- 活动-钓鱼达人 

REQ_FISHING_ASK_GO_FISH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FISHING_ASK_GO_FISH
	self:init(0, nil)
end)
