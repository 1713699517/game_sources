
require "common/AcknowledgementMessage"

-- [51240]获取其他玩家获奖信息块 -- 每日一箭 

ACK_SHOOT_AWARD_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_AWARD_INFO
	self:init()
end)

function ACK_SHOOT_AWARD_INFO.deserialize(self, reader)
	self.uname = reader:readUTF() -- {获奖玩家名称}
	self.reward = reader:readUTF() -- {获得的奖品}
end

-- {获奖玩家名称}
function ACK_SHOOT_AWARD_INFO.getUname(self)
	return self.uname
end

-- {获得的奖品}
function ACK_SHOOT_AWARD_INFO.getReward(self)
	return self.reward
end
