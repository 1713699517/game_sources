
require "common/AcknowledgementMessage"

-- [40531]攻守列表 -- 天宫之战 

ACK_SKYWAR_LIST_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_LIST_DATA
	self:init()
end)

-- {数量}
function ACK_SKYWAR_LIST_DATA.getCount(self)
	return self.count
end

-- {40532信息块}
function ACK_SKYWAR_LIST_DATA.getMsgXxx(self)
	return self.msg_xxx
end
