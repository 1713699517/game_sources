
require "common/AcknowledgementMessage"

-- [46260]刷新魔王副本返回 -- 魔王副本 

ACK_FIEND_FRESH_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIEND_FRESH_BACK
	self:init()
end)

function ACK_FIEND_FRESH_BACK.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.times = reader:readInt16Unsigned() -- {可进入次数}
end

-- {副本ID}
function ACK_FIEND_FRESH_BACK.getCopyId(self)
	return self.copy_id
end

-- {可进入次数}
function ACK_FIEND_FRESH_BACK.getTimes(self)
	return self.times
end
