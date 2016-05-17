
require "common/AcknowledgementMessage"

-- [55830]战役数据信息块 -- 拳皇生涯 

ACK_FIGHTERS_MSG_BATTLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_MSG_BATTLE
	self:init()
end)

function ACK_FIGHTERS_MSG_BATTLE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {可以挑战的副本Id}
end

-- {可以挑战的副本Id}
function ACK_FIGHTERS_MSG_BATTLE.getCopyId(self)
	return self.copy_id
end
