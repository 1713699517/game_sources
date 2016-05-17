
require "common/AcknowledgementMessage"

-- [3612]队伍战役信息 -- 组队系统 

ACK_TEAM_BATTLE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_BATTLE_DATA
	self:init()
end)

-- {队伍战役数量}
function ACK_TEAM_BATTLE_DATA.getCount(self)
	return self.count
end

-- {队伍战役信息块(3613)}
function ACK_TEAM_BATTLE_DATA.getData(self)
	return self.data
end
