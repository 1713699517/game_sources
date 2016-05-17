
require "common/AcknowledgementMessage"

-- [10740]更新称号 -- 称号 

ACK_TITLE_GET = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_GET
	self:init()
end)

-- {(true:添加 | false:删除)}
function ACK_TITLE_GET.getFlag(self)
	return self.flag
end

-- {true:启用中 | false:未启用}
function ACK_TITLE_GET.getState(self)
	return self.state
end

-- {类型(见常量)}
function ACK_TITLE_GET.getType(self)
	return self.type
end

-- {固定称号}
function ACK_TITLE_GET.getTid(self)
	return self.tid
end

-- {称号名字}
function ACK_TITLE_GET.getName(self)
	return self.name
end
