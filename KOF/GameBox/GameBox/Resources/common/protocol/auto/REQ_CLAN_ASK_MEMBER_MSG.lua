
require "common/RequestMessage"

-- [33130]请求帮派成员列表 -- 社团 

REQ_CLAN_ASK_MEMBER_MSG = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_MEMBER_MSG
	self:init(1 ,{ 33140,700 })
end)
