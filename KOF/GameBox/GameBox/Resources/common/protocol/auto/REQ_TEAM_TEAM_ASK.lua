
require "common/RequestMessage"

-- (手动) -- [3595]请求队伍信息 -- 组队系统 

REQ_TEAM_TEAM_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_TEAM_ASK
	self:init()
end)
