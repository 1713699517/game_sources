
require "common/RequestMessage"

-- [54801]请求活动报名 -- 格斗之王 

REQ_WRESTLE_BOOK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_BOOK
	self:init(0, nil)
end)
