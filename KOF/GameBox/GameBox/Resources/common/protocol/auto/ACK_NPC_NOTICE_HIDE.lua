
require "common/AcknowledgementMessage"

-- [26110]隐藏队伍 -- NPC 

ACK_NPC_NOTICE_HIDE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NPC_NOTICE_HIDE
	self:init()
end)

function ACK_NPC_NOTICE_HIDE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {UID}
end

-- {UID}
function ACK_NPC_NOTICE_HIDE.getUid(self)
	return self.uid
end
