
require "common/AcknowledgementMessage"

-- [3675]上阵伙伴信息返回 -- 组队系统 

ACK_TEAM_CHOICE_PAR_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_CHOICE_PAR_DATA
	self:init()
end)

-- {服务器ID}
function ACK_TEAM_CHOICE_PAR_DATA.getSid(self)
	return self.sid
end

-- {玩家Uid}
function ACK_TEAM_CHOICE_PAR_DATA.getUid(self)
	return self.uid
end

-- {伙伴数量}
function ACK_TEAM_CHOICE_PAR_DATA.getCount(self)
	return self.count
end

-- {伙伴信息块(3505)}
function ACK_TEAM_CHOICE_PAR_DATA.getPartData(self)
	return self.part_data
end
