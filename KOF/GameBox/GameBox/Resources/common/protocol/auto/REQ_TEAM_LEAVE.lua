
require "common/RequestMessage"

-- [3610]离开队伍 -- 组队系统 

REQ_TEAM_LEAVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_LEAVE
	self:init(0 ,{ 3620,700 })
end)
