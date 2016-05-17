
require "common/AcknowledgementMessage"

-- [33095]返回审核结果 -- 社团 

ACK_CLAN_OK_AUDIT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_AUDIT
	self:init()
end)

function ACK_CLAN_OK_AUDIT.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.state = reader:readInt8Unsigned() -- {审核结果 1 true| 0 false}
end

-- {玩家Uid}
function ACK_CLAN_OK_AUDIT.getUid(self)
	return self.uid
end

-- {审核结果 1 true| 0 false}
function ACK_CLAN_OK_AUDIT.getState(self)
	return self.state
end
