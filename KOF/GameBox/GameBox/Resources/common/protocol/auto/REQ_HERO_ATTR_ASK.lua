
require "common/RequestMessage"

-- (手动) -- [39565]请求玩家属性加成 -- 英雄副本 

REQ_HERO_ATTR_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_ATTR_ASK
	self:init()
end)
