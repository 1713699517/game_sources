
require "common/RequestMessage"

-- [47270]金元刷新面板 -- 珍宝阁系统 

REQ_TREASURE_MONEY_REFRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_MONEY_REFRESH
	self:init(1 ,{ 47280,700,47285 })
end)
