
require "common/AcknowledgementMessage"

-- [2272]一键互换成功 -- 物品/背包 

ACK_GOODS_SWAP_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SWAP_OK
	self:init()
end)
