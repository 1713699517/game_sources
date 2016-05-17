
require "common/RequestMessage"

-- [2330]请求次数物品数据 -- 物品/背包 

REQ_GOODS_TIMES_GOODS_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_TIMES_GOODS_ASK
	self:init(0, nil)
end)
