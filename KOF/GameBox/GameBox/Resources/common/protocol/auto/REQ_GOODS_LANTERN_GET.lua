
require "common/RequestMessage"

-- [2328]领取将要获得的物品 -- 物品/背包 

REQ_GOODS_LANTERN_GET = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_LANTERN_GET
	self:init(0, nil)
end)
