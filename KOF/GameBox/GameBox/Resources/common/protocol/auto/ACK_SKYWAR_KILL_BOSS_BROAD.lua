
require "common/AcknowledgementMessage"

-- [40570]击杀boss广播 -- 天宫之战 

ACK_SKYWAR_KILL_BOSS_BROAD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_KILL_BOSS_BROAD
	self:init()
end)

function ACK_SKYWAR_KILL_BOSS_BROAD.deserialize(self, reader)
	self.wall = reader:readInt8Unsigned() -- {1:外墙|2:内墙}
end

-- {1:外墙|2:内墙}
function ACK_SKYWAR_KILL_BOSS_BROAD.getWall(self)
	return self.wall
end
