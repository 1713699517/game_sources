
require "common/RequestMessage"

-- [33320]请求浇水 -- 社团 

REQ_CLAN_ASK_WATER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_WATER
	self:init(1 ,{ 33330,700 })
end)
