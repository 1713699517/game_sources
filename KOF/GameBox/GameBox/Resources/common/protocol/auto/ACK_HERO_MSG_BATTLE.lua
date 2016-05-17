
require "common/AcknowledgementMessage"

-- [39030]战役数据信息块 -- 英雄副本 

ACK_HERO_MSG_BATTLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_MSG_BATTLE
	self:init()
end)

function ACK_HERO_MSG_BATTLE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.is_pass = reader:readInt8Unsigned() -- {是否通关过(1：是 0：否)}
end

-- {副本ID}
function ACK_HERO_MSG_BATTLE.getCopyId(self)
	return self.copy_id
end

-- {是否通关过(1：是 0：否)}
function ACK_HERO_MSG_BATTLE.getIsPass(self)
	return self.is_pass
end
