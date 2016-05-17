
require "common/AcknowledgementMessage"

-- [2552]宝石合成成功 -- 物品/打造/强化 

ACK_MAKE_COMPOSE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_COMPOSE_OK
	self:init()
end)
