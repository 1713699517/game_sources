
require "common/AcknowledgementMessage"

-- [54205]活动倒计时 -- 社团BOSS 

ACK_CLAN_BOSS_TIME_DOWN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_TIME_DOWN
	self:init()
end)

function ACK_CLAN_BOSS_TIME_DOWN.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {计时类型 0 开启前| 1结束}
	self.time = reader:readInt16Unsigned() -- {倒计时时长（s）}
end

-- {计时类型 0 开启前| 1结束}
function ACK_CLAN_BOSS_TIME_DOWN.getType(self)
	return self.type
end

-- {倒计时时长（s）}
function ACK_CLAN_BOSS_TIME_DOWN.getTime(self)
	return self.time
end
