
require "common/RequestMessage"

-- (手动) -- [3660]快速进入队伍 -- 组队系统 

REQ_TEAM_QUICK_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_QUICK_TEAM
	self:init()
end)
