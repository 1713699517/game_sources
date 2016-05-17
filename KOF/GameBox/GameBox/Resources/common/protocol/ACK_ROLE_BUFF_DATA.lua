
require "common/AcknowledgementMessage"

-- [1355]buff数据(欲废除) -- 角色 

ACK_ROLE_BUFF_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_BUFF_DATA
	self:init()
end)

-- {buff数量}
function ACK_ROLE_BUFF_DATA.getCount(self)
	return self.count
end

-- {buff的id}
function ACK_ROLE_BUFF_DATA.getData(self)
	return self.data
end
