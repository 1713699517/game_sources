
require "common/RequestMessage"

-- [33200]请求帮派技能面板 -- 社团 

REQ_CLAN_ASK_CLAN_SKILL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_CLAN_SKILL
	self:init(1 ,{ 33210,700 })
end)
