
require "common/RequestMessage"

-- [45790]请求退出活动 -- 活动-阵营战 

REQ_CAMPWAR_ASK_BACK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CAMPWAR_ASK_BACK
	self:init(0, nil)
end)
