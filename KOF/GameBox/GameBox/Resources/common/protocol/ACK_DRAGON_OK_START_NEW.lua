
require "common/AcknowledgementMessage"

-- [34042]寻宝结果 -- 活动-龙宫寻宝 

ACK_DRAGON_OK_START_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DRAGON_OK_START_NEW
	self:init()
end)

-- {服务器Id}
function ACK_DRAGON_OK_START_NEW.getSid(self)
	return self.sid
end

-- {玩家Uid}
function ACK_DRAGON_OK_START_NEW.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_DRAGON_OK_START_NEW.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_DRAGON_OK_START_NEW.getNameColor(self)
	return self.name_color
end

-- {数量}
function ACK_DRAGON_OK_START_NEW.getCount(self)
	return self.count
end

-- {奖励信息块 【34050】}
function ACK_DRAGON_OK_START_NEW.getRewards(self)
	return self.rewards
end
