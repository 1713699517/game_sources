
require "common/AcknowledgementMessage"

-- [3610]队伍人员信息块 -- 组队系统 

ACK_TEAM_MSG_MEMBER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_MSG_MEMBER
	self:init()
end)

-- {成员Sid}
function ACK_TEAM_MSG_MEMBER.getSid(self)
	return self.sid
end

-- {成员Uid}
function ACK_TEAM_MSG_MEMBER.getUid(self)
	return self.uid
end

-- {在队伍中的位置}
function ACK_TEAM_MSG_MEMBER.getPos(self)
	return self.pos
end

-- {成员姓名}
function ACK_TEAM_MSG_MEMBER.getName(self)
	return self.name
end

-- {成员姓名颜色}
function ACK_TEAM_MSG_MEMBER.getNameColor(self)
	return self.name_color
end

-- {成员等级}
function ACK_TEAM_MSG_MEMBER.getLv(self)
	return self.lv
end

-- {成员战斗力}
function ACK_TEAM_MSG_MEMBER.getPowerful(self)
	return self.powerful
end

-- {成员职业}
function ACK_TEAM_MSG_MEMBER.getPro(self)
	return self.pro
end

-- {成员性别}
function ACK_TEAM_MSG_MEMBER.getSex(self)
	return self.sex
end

-- {成员阵营}
function ACK_TEAM_MSG_MEMBER.getCountry(self)
	return self.country
end

-- {剩余奖励次数}
function ACK_TEAM_MSG_MEMBER.getRewardTimes(self)
	return self.reward_times
end

-- {伙伴数量}
function ACK_TEAM_MSG_MEMBER.getCount(self)
	return self.count
end

-- {伙伴信息块(3505)}
function ACK_TEAM_MSG_MEMBER.getPartData(self)
	return self.part_data
end
