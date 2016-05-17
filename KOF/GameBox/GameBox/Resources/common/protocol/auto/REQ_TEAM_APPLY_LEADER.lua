
require "common/RequestMessage"

-- [3650]申请做队长 -- 组队系统 

REQ_TEAM_APPLY_LEADER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_APPLY_LEADER
	self:init(0 ,{ 3660,700 })
end)
