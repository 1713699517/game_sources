
require "common/AcknowledgementMessage"

-- (手动) -- [39034]通知前端弹出增加进入次数面板 -- 取经之路 

ACK_PILROAD_NOTICE_ADD_TIMES = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_NOTICE_ADD_TIMES
	self:init()
end)

function ACK_PILROAD_NOTICE_ADD_TIMES.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {战役Id}
	self.reset_rmb = reader:readInt32Unsigned() -- {一次消耗元宝}
end

-- {战役Id}
function ACK_PILROAD_NOTICE_ADD_TIMES.getCopyId(self)
	return self.copy_id
end

-- {一次消耗元宝}
function ACK_PILROAD_NOTICE_ADD_TIMES.getResetRmb(self)
	return self.reset_rmb
end
