
require "common/RequestMessage"

-- (手动) -- [3690]请求队伍阵型系统 -- 组队系统 

REQ_TEAM_ARRAY_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_ARRAY_LIST
	self:init()
end)
