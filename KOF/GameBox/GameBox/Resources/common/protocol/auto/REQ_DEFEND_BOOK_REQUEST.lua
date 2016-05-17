
require "common/RequestMessage"

-- [21110]请求参加怪物攻城 -- 活动-保卫经书 

REQ_DEFEND_BOOK_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_REQUEST
	self:init(0, nil)
end)
