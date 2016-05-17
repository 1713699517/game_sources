
require "common/AcknowledgementMessage"

-- [54290]状态返回 -- 社团BOSS 

ACK_CLAN_BOSS_DIED_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_DIED_STATE
	self:init()
end)

function ACK_CLAN_BOSS_DIED_STATE.deserialize(self, reader)
	self.time = reader:readInt16Unsigned() -- {距复活倒计时时长（s）}
	self.spend = reader:readInt16Unsigned() -- {复活需花费的钻石数}
end

-- {距复活倒计时时长（s）}
function ACK_CLAN_BOSS_DIED_STATE.getTime(self)
	return self.time
end

-- {复活需花费的钻石数}
function ACK_CLAN_BOSS_DIED_STATE.getSpend(self)
	return self.spend
end
