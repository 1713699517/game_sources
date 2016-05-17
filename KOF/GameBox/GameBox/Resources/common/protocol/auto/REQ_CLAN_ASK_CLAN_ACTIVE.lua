
require "common/RequestMessage"

-- [33300]请求帮派活动面板 -- 社团 

REQ_CLAN_ASK_CLAN_ACTIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_CLAN_ACTIVE
	self:init(1 ,{ 33310,700 })
end)
