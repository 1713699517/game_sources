
require "common/RequestMessage"

-- (手动) -- [52250]请求神器商店面板 -- 神器 

REQ_MAGIC_EQUIP_SHOP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_SHOP
	self:init()
end)
