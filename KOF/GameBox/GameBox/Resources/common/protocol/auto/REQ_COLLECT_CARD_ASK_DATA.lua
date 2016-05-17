
require "common/RequestMessage"

-- [42520]请求卡片套装和奖励数据 -- 收集卡片 

REQ_COLLECT_CARD_ASK_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COLLECT_CARD_ASK_DATA
	self:init(0, nil)
end)
