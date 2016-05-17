
require "common/AcknowledgementMessage"

-- [37090]返回结果 -- 世界BOSS 

ACK_WORLD_BOSS_WAR_RS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_WAR_RS
	self:init()
end)

function ACK_WORLD_BOSS_WAR_RS.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {复活时间}
	self.rmb = reader:readInt16Unsigned() -- {金元}
end

-- {复活时间}
function ACK_WORLD_BOSS_WAR_RS.getTime(self)
	return self.time
end

-- {金元}
function ACK_WORLD_BOSS_WAR_RS.getRmb(self)
	return self.rmb
end
