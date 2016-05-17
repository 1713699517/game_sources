
require "common/AcknowledgementMessage"

-- [5950]场景广播-改变组队 -- 场景 

ACK_SCENE_CHANGE_TEAM = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_TEAM
	self:init()
end)

function ACK_SCENE_CHANGE_TEAM.deserialize(self, reader)
	self.new_leader_uid = reader:readInt32Unsigned() -- {新队长Uid(没有队伍时为0)}
	self.old_leader_uid = reader:readInt32Unsigned() -- {旧队长Uid(没有队伍时为0)}
end

-- {新队长Uid(没有队伍时为0)}
function ACK_SCENE_CHANGE_TEAM.getNewLeaderUid(self)
	return self.new_leader_uid
end

-- {旧队长Uid(没有队伍时为0)}
function ACK_SCENE_CHANGE_TEAM.getOldLeaderUid(self)
	return self.old_leader_uid
end
