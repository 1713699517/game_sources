
require "common/AcknowledgementMessage"

-- [33305]玩家现有体能值 -- 社团 

ACK_CLAN_NOW_STAMINA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_NOW_STAMINA
	self:init()
end)

function ACK_CLAN_NOW_STAMINA.deserialize(self, reader)
	self.stamina = reader:readInt32Unsigned() -- {}
end

-- {}
function ACK_CLAN_NOW_STAMINA.getStamina(self)
	return self.stamina
end
