
require "common/AcknowledgementMessage"

-- [1360]buff数据 -- 角色 

ACK_ROLE_BUFF1_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_BUFF1_DATA
	self:init()
end)

-- {buff数量}
function ACK_ROLE_BUFF1_DATA.getCount(self)
	return self.count
end

-- {buffs数据(1365)}
function ACK_ROLE_BUFF1_DATA.getData(self)
	return self.data
end
