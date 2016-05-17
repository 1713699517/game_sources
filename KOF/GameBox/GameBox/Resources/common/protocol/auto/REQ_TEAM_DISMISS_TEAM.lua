
require "common/RequestMessage"

-- (手动) -- [3640]解散队伍 -- 组队系统 

REQ_TEAM_DISMISS_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_DISMISS_TEAM
	self:init()
end)
