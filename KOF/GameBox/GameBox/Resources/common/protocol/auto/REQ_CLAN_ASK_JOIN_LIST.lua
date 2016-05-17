
require "common/RequestMessage"

-- [33070]请求入帮申请列表 -- 社团 

REQ_CLAN_ASK_JOIN_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_JOIN_LIST
	self:init(1 ,{ 33080,700 })
end)
