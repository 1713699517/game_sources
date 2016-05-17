
require "common/RequestMessage"

-- [21260]请求退出战斗 -- 活动-保卫经书 

REQ_DEFEND_BOOK_REQUEST_BACK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_REQUEST_BACK
	self:init(0, nil)
end)
