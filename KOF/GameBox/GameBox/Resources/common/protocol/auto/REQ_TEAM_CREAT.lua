
require "common/RequestMessage"

-- [3570]创建队伍 -- 组队系统 

REQ_TEAM_CREAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_CREAT
	self:init(0 ,{ 3580,700 })
end)

function REQ_TEAM_CREAT.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_TEAM_CREAT.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_TEAM_CREAT.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_TEAM_CREAT.getCopyId(self)
	return self.copy_id
end
