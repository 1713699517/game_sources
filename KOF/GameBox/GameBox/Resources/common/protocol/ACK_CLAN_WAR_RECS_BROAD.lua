
require "common/AcknowledgementMessage"

-- [33340]社团战战报(场景广播) -- 社团 

ACK_CLAN_WAR_RECS_BROAD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_WAR_RECS_BROAD
	self:init()
end)

-- {数据块33339}
function ACK_CLAN_WAR_RECS_BROAD.getMsgXxx(self)
	return self.msg_xxx
end
