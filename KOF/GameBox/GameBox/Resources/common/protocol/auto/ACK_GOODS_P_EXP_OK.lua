
require "common/AcknowledgementMessage"

-- [2081]伙伴经验丹使用成功 -- 物品/背包 

ACK_GOODS_P_EXP_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_P_EXP_OK
	self:init()
end)
