
require "common/AcknowledgementMessage"

-- [37160]返回消耗信息 -- 世界BOSS 

ACK_WORLD_BOSS_RMB_USE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_RMB_USE
	self:init()
end)

function ACK_WORLD_BOSS_RMB_USE.deserialize(self, reader)
	self.count = reader:readInt8Unsigned() -- {次数}
	self.rmb = reader:readInt32Unsigned() -- {金元}
end

-- {次数}
function ACK_WORLD_BOSS_RMB_USE.getCount(self)
	return self.count
end

-- {金元}
function ACK_WORLD_BOSS_RMB_USE.getRmb(self)
	return self.rmb
end
