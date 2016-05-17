
require "common/AcknowledgementMessage"

-- [26020]通知--删除队伍 -- NPC 

ACK_NPC_NOTICE_DELETE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NPC_NOTICE_DELETE
	self:init()
end)

function ACK_NPC_NOTICE_DELETE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {队长Uid}
end

-- {队长Uid}
function ACK_NPC_NOTICE_DELETE.getUid(self)
	return self.uid
end
