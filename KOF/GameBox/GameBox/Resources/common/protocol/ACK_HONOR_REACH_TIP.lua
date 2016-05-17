
require "common/AcknowledgementMessage"

-- [18150]荣誉达成提示 -- 荣誉 

ACK_HONOR_REACH_TIP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HONOR_REACH_TIP
	self:init()
end)

-- {数量}
function ACK_HONOR_REACH_TIP.getCount(self)
	return self.count
end

-- {荣誉类型}
function ACK_HONOR_REACH_TIP.getType(self)
	return self.type
end

-- {荣誉子类型}
function ACK_HONOR_REACH_TIP.getTypeSub(self)
	return self.type_sub
end

-- {荣誉ID}
function ACK_HONOR_REACH_TIP.getId(self)
	return self.id
end
