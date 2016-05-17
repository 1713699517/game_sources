
require "common/RequestMessage"

-- (手动) -- [3730]全服邀请组队 -- 组队系统 

REQ_TEAM_INVITE_ALL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_INVITE_ALL
	self:init()
end)
