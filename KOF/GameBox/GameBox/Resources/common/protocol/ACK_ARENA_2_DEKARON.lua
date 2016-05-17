
require "common/AcknowledgementMessage"

-- [23811]可以挑战的玩家列表(新) -- 封神台 

ACK_ARENA_2_DEKARON = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_2_DEKARON
	self:init()
end)

-- {世界封神等级}
function ACK_ARENA_2_DEKARON.getArenaLv(self)
	return self.arena_lv
end

-- {玩家个数}
function ACK_ARENA_2_DEKARON.getCount(self)
	return self.count
end

-- {23821}
function ACK_ARENA_2_DEKARON.getChallageplayerdata(self)
	return self.challageplayerdata
end
