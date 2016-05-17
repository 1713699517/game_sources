
require "common/RequestMessage"

-- (手动) -- [3636]申请做队长 -- 组队系统 

REQ_TEAM_LEADER_APPLY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_LEADER_APPLY
	self:init()
end)
