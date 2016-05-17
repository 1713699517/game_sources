
require "common/AcknowledgementMessage"

-- (手动) -- [46280]战役数据信息块(new) -- 魔王副本 

ACK_FIEND_MSG_BATTLE_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIEND_MSG_BATTLE_NEW
	self:init()
end)

function ACK_FIEND_MSG_BATTLE_NEW.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.times = reader:readInt16Unsigned() -- {可以进入次数}
	self.is_pass = reader:readInt8Unsigned() -- {是否通关过(1：是 0：否)}
	self.eva = reader:readInt8Unsigned() -- {副本评价}
    print("副本ID:",self.copy_id,"Times:",self.times,"Is_pass:",self.is_pass,"Eva:",self.eva)
end

-- {副本ID}
function ACK_FIEND_MSG_BATTLE_NEW.getCopyId(self)
	return self.copy_id
end

-- {可以进入次数}
function ACK_FIEND_MSG_BATTLE_NEW.getTimes(self)
	return self.times
end

-- {是否通关过(1：是 0：否)}
function ACK_FIEND_MSG_BATTLE_NEW.getIsPass(self)
	return self.is_pass
end

-- {副本评价}
function ACK_FIEND_MSG_BATTLE_NEW.getEva(self)
	return self.eva
end
