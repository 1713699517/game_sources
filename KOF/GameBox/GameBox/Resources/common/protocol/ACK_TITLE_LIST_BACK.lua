
require "common/AcknowledgementMessage"

-- [10712]称号列表数据返回 -- 称号 

ACK_TITLE_LIST_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_LIST_BACK
	self:init()
end)

-- {10701数据块}
function ACK_TITLE_LIST_BACK.getMsgNo(self)
	return self.msg_no
end
