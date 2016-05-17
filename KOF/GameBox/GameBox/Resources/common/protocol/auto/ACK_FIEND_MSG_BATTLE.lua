
require "common/AcknowledgementMessage"

-- [46230]战役数据信息块 -- 魔王副本 

ACK_FIEND_MSG_BATTLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIEND_MSG_BATTLE
	self:init()
end)

function ACK_FIEND_MSG_BATTLE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.times = reader:readInt16Unsigned() -- {可以进入次数}
	self.is_pass = reader:readInt8Unsigned() -- {是否通关过(1：是 0：否)}
end

-- {副本ID}
function ACK_FIEND_MSG_BATTLE.getCopyId(self)
	return self.copy_id
end

-- {可以进入次数}
function ACK_FIEND_MSG_BATTLE.getTimes(self)
	return self.times
end

-- {是否通关过(1：是 0：否)}
function ACK_FIEND_MSG_BATTLE.getIsPass(self)
	return self.is_pass
end
