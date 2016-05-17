
require "common/AcknowledgementMessage"

-- [4014]添加成功-插入新联系人 -- 好友 

ACK_FRIEND_INSERT_ADD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_INSERT_ADD
	self:init()
end)

-- {联系人协议块（4003）}
function ACK_FRIEND_INSERT_ADD.getContactXxx(self)
	return self.contact_xxx
end
