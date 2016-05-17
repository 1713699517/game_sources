
require "common/RequestMessage"

-- [2329]请求元宵活动数据 -- 物品/背包 

REQ_GOODS_LANTERN_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_LANTERN_ASK
	self:init(0, nil)
end)
