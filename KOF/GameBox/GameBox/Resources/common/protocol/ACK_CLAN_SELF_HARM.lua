
require "common/AcknowledgementMessage"

-- [33410]自己伤害 -- 社团 

ACK_CLAN_SELF_HARM = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_SELF_HARM
	self:init()
end)

-- {协议快(37053)}
function ACK_CLAN_SELF_HARM.getDataXxx(self)
	return self.data_xxx
end
