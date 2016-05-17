
require "common/RequestMessage"

-- [42510]查询是否有卡片活动 -- 收集卡片 

REQ_COLLECT_CARD_ASK_LIMIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COLLECT_CARD_ASK_LIMIT
	self:init(0, nil)
end)
