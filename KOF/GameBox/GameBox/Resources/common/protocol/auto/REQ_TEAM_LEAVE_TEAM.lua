
require "common/RequestMessage"

-- (手动) -- [3620]退出队伍 -- 组队系统 

REQ_TEAM_LEAVE_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_LEAVE_TEAM
	self:init()
end)
