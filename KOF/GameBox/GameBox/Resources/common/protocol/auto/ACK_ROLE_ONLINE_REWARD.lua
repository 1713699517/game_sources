
require "common/AcknowledgementMessage"

-- [1340]在线奖励 -- 角色 

ACK_ROLE_ONLINE_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_ONLINE_REWARD
	self:init()
end)

function ACK_ROLE_ONLINE_REWARD.deserialize(self, reader)
	self.time = reader:readInt8Unsigned() -- {时间}
	self.stime = reader:readInt32Unsigned() -- {剩余时间}
end

-- {时间}
function ACK_ROLE_ONLINE_REWARD.getTime(self)
	return self.time
end

-- {剩余时间}
function ACK_ROLE_ONLINE_REWARD.getStime(self)
	return self.stime
end
