
require "common/AcknowledgementMessage"

-- [28000]返回伙伴信息数据 -- 布阵 

ACK_ARRAY_LIST_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARRAY_LIST_DATA
	self:init()
end)

-- {可上阵人数}
function ACK_ARRAY_LIST_DATA.getSum(self)
	return self.sum
end

-- {数量}
function ACK_ARRAY_LIST_DATA.getCount(self)
	return self.count
end

-- {布阵伙伴信息块(28050)}
function ACK_ARRAY_LIST_DATA.getRoleInfo(self)
	return self.role_info
end
