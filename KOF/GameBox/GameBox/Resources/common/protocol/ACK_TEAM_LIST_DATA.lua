
require "common/AcknowledgementMessage"

-- [3695]返回队伍伙伴信息数据 -- 组队系统 

ACK_TEAM_LIST_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_LIST_DATA
	self:init()
end)

-- {数量}
function ACK_TEAM_LIST_DATA.getCount(self)
	return self.count
end

-- {布阵伙伴信息块(3700}
function ACK_TEAM_LIST_DATA.getPartInfo(self)
	return self.part_info
end
