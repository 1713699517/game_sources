
require "common/RequestMessage"

-- [6510]请求技能列表 -- 技能系统 

REQ_SKILL_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_REQUEST
	self:init(1 ,{ 6520,700,6530,6545 })
end)
