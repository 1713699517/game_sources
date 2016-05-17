
require "common/AcknowledgementMessage"

-- [33420]dps -- 社团 

ACK_CLAN_DATA_DPS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_DATA_DPS
	self:init()
end)

-- {协议快(37060)}
function ACK_CLAN_DATA_DPS.getDataDps(self)
	return self.data_dps
end
