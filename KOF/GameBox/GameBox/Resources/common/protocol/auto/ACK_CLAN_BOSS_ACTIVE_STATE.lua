
require "common/AcknowledgementMessage"

-- [54235]界面信息返回--活动状态 -- 社团BOSS 

ACK_CLAN_BOSS_ACTIVE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_ACTIVE_STATE
	self:init()
end)

function ACK_CLAN_BOSS_ACTIVE_STATE.deserialize(self, reader)
	self.active_time = reader:readInt16Unsigned() -- {活动剩余时长}
	self.map_id = reader:readInt16Unsigned() -- {活动地图ID}
	self.clan_id = reader:readInt32Unsigned() -- {帮派ID}
	self.is_boss = reader:readInt8Unsigned() -- {BOSS是否存在 0 未刷出 | 1 刷出 | 2 已死亡}
end

-- {活动剩余时长}
function ACK_CLAN_BOSS_ACTIVE_STATE.getActiveTime(self)
	return self.active_time
end

-- {活动地图ID}
function ACK_CLAN_BOSS_ACTIVE_STATE.getMapId(self)
	return self.map_id
end

-- {帮派ID}
function ACK_CLAN_BOSS_ACTIVE_STATE.getClanId(self)
	return self.clan_id
end

-- {BOSS是否存在 0 未刷出 | 1 刷出 | 2 已死亡}
function ACK_CLAN_BOSS_ACTIVE_STATE.getIsBoss(self)
	return self.is_boss
end
