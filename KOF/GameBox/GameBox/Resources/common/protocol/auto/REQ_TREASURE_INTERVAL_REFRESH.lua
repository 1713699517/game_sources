
require "common/RequestMessage"

-- [47275]定时刷新 -- 珍宝阁系统 

REQ_TREASURE_INTERVAL_REFRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_INTERVAL_REFRESH
	self:init(1 ,{ 47280,700,47285 })
end)
