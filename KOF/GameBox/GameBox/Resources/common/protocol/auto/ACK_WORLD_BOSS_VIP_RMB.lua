
require "common/AcknowledgementMessage"

-- [37051]是否开启鼓舞 -- 世界BOSS 

ACK_WORLD_BOSS_VIP_RMB = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_VIP_RMB
	self:init()
end)
