
require "common/AcknowledgementMessage"

-- [22850]宠物通知 -- 宠物 

ACK_PET_UP_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_UP_NOTICE
	self:init()
end)

-- {类型（见常量：CONST_PET_NOTICE_TYPE_*）}
function ACK_PET_UP_NOTICE.getType(self)
	return self.type
end

-- {宠物消息块(22801)}
function ACK_PET_UP_NOTICE.getMsgPet(self)
	return self.msg_pet
end
