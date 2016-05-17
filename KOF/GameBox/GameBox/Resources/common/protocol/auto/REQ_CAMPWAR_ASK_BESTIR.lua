
require "common/RequestMessage"

-- [45680]请求振奋 -- 活动-阵营战 

REQ_CAMPWAR_ASK_BESTIR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_ASK_BESTIR
	self:init(0, nil)
end)
