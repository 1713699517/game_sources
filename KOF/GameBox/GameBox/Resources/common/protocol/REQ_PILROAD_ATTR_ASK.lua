
require "common/RequestMessage"

-- (手动) -- [39565]请求玩家属性加成 -- 取经之路 

REQ_PILROAD_ATTR_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_ATTR_ASK
	self:init()
end)
