
require "common/AcknowledgementMessage"

-- [7660]副本奖励返回信息 -- 副本 

ACK_COPY_REPLY_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_REPLY_REWARD
	self:init()
end)

-- {副本ID}
function ACK_COPY_REPLY_REWARD.getCopyId(self)
	return self.copy_id
end

-- {玩家数量}
function ACK_COPY_REPLY_REWARD.getCount(self)
	return self.count
end

-- {玩家奖励信息}
function ACK_COPY_REPLY_REWARD.getData(self)
	return self.data
end
