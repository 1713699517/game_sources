
require "common/AcknowledgementMessage"

-- [33400]返回boss显示数据 -- 社团 

ACK_CLAN_BOSS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_DATA
	self:init()
end)

-- {信息块(37050)}
function ACK_CLAN_BOSS_DATA.getDataboss(self)
	return self.databoss
end
