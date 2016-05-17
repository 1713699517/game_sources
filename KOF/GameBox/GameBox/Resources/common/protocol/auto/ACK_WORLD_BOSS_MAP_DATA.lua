
require "common/AcknowledgementMessage"

-- [37020]返回地图数据 -- 世界BOSS 

ACK_WORLD_BOSS_MAP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_MAP_DATA
	self:init()
end)

function ACK_WORLD_BOSS_MAP_DATA.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {开始时间}
	self.stime = reader:readInt32Unsigned() -- {结束时间}
end

-- {开始时间}
function ACK_WORLD_BOSS_MAP_DATA.getTime(self)
	return self.time
end

-- {结束时间}
function ACK_WORLD_BOSS_MAP_DATA.getStime(self)
	return self.stime
end
