
require "common/RequestMessage"

-- [47260]请求商店面板 -- 珍宝阁系统 

REQ_TREASURE_SHOP_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_SHOP_REQUEST
	self:init(1 ,{ 47280,700,47285 })
end)
