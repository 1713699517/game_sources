
require "common/RequestMessage"

-- [26100]NPC进入(战场|副本|各种组队玩法) -- NPC 

REQ_NPC_TEAM_ENTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_TEAM_ENTER
	self:init(0, nil)
end)

function REQ_NPC_TEAM_ENTER.serialize(self, writer)
	writer:writeInt8Unsigned(self.param)  -- {参数}
end

function REQ_NPC_TEAM_ENTER.setArguments(self,param)
	self.param = param  -- {参数}
end

-- {参数}
function REQ_NPC_TEAM_ENTER.setParam(self, param)
	self.param = param
end
function REQ_NPC_TEAM_ENTER.getParam(self)
	return self.param
end
