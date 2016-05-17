
require "common/AcknowledgementMessage"

-- [37120]复活成功 -- 世界BOSS 

ACK_WORLD_BOSS_REVIVE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_REVIVE_OK
	self:init()
end)
