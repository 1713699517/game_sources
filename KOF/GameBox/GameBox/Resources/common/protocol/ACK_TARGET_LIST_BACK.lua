
require "common/AcknowledgementMessage"

-- [38010]目标数据返回 -- 目标任务 

ACK_TARGET_LIST_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TARGET_LIST_BACK
	self:init()
end)

-- {目标数量}
function ACK_TARGET_LIST_BACK.getCount(self)
	return self.count
end

-- {(38015)}
function ACK_TARGET_LIST_BACK.getData(self)
	return self.data
end
