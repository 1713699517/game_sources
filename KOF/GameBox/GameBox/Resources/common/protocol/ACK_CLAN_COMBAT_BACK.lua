
require "common/AcknowledgementMessage"

-- [33345]社团战战绩返回 -- 社团 

ACK_CLAN_COMBAT_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_COMBAT_BACK
	self:init()
end)

-- {社团战个人排位(数量)}
function ACK_CLAN_COMBAT_BACK.getCountP(self)
	return self.count_p
end

-- {信息块33342}
function ACK_CLAN_COMBAT_BACK.getPersonalMsg(self)
	return self.personal_msg
end

-- {社团战社团排位(数量)}
function ACK_CLAN_COMBAT_BACK.getCountC(self)
	return self.count_c
end

-- {信息块33341}
function ACK_CLAN_COMBAT_BACK.getClanMsg(self)
	return self.clan_msg
end
