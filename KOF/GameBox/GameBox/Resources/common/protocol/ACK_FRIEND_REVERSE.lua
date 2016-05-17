
require "common/AcknowledgementMessage"

-- [4005]请求数据返回 -- 好友 

ACK_FRIEND_REVERSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_REVERSE
	self:init()
end)

-- {好友数量(循环)}
function ACK_FRIEND_REVERSE.getCount(self)
	return self.count
end

-- {联系人协议块（4003）}
function ACK_FRIEND_REVERSE.getContactXxx(self)
	return self.contact_xxx
end
