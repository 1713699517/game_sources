
require "common/RequestMessage"

-- [21280]请求领取增益 -- 活动-保卫经书 

REQ_DEFEND_BOOK_GAIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_GAIN
	self:init(0, nil)
end)
