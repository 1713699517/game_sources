
require "common/AcknowledgementMessage"

-- [39022]取经战役信息块 -- 取经之路 

ACK_PILROAD_MSG_PILROAD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_MSG_PILROAD
	self:init()
end)

-- {副本ID}
function ACK_PILROAD_MSG_PILROAD.getCopyId(self)
	return self.copy_id
end

-- {副本模式(1：单人 2:多人)}
function ACK_PILROAD_MSG_PILROAD.getCopyMod(self)
	return self.copy_mod
end

-- {已进入次数(单人)}
function ACK_PILROAD_MSG_PILROAD.getNowtimes(self)
	return self.nowtimes
end

-- {总次数(单人)}
function ACK_PILROAD_MSG_PILROAD.getSumtimes(self)
	return self.sumtimes
end

-- {是否可以进入(单人)}
function ACK_PILROAD_MSG_PILROAD.getScanin(self)
	return self.scanin
end

-- {最佳击破玩家(单人)}
function ACK_PILROAD_MSG_PILROAD.getBestName(self)
	return self.best_name
end

-- {首次击破玩家(单人)}
function ACK_PILROAD_MSG_PILROAD.getFirstName(self)
	return self.first_name
end

-- {剩余奖励次数(多人)}
function ACK_PILROAD_MSG_PILROAD.getSurtimes(self)
	return self.surtimes
end

-- {是否可以进入(多人)}
function ACK_PILROAD_MSG_PILROAD.getMcanin(self)
	return self.mcanin
end
