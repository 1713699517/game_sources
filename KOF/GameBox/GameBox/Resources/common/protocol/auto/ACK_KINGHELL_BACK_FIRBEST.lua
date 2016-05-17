
require "common/AcknowledgementMessage"

-- [44745]首次和最佳记录返回 -- 阎王殿 

ACK_KINGHELL_BACK_FIRBEST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_KINGHELL_BACK_FIRBEST
	self:init()
end)

function ACK_KINGHELL_BACK_FIRBEST.deserialize(self, reader)
	self.mons_id = reader:readInt16Unsigned() -- {怪物id}
	self.dt_first_sid = reader:readInt16Unsigned() -- {单挑首次击破玩家sid}
	self.dt_first_uid = reader:readInt32Unsigned() -- {单挑首次击破玩家uid}
	self.dt_first_uname = reader:readString() -- {单挑首次击破玩家名字}
	self.dt_first_warid = reader:readInt32Unsigned() -- {单挑首次击破玩家战报id}
	self.zs_first_sid = reader:readInt16Unsigned() -- {正式首次击破玩家sid}
	self.zs_first_uid = reader:readInt32Unsigned() -- {正式首次击破玩家uid}
	self.zs_first_uname = reader:readString() -- {正式首次击破玩家名字}
	self.zs_first_warid = reader:readInt32Unsigned() -- {正式首次击破玩家战报id}
	self.dt_best_sid = reader:readInt16Unsigned() -- {单挑最佳击破玩家sid}
	self.dt_best_uid = reader:readInt32Unsigned() -- {单挑最佳击破玩家uid}
	self.dt_best_uname = reader:readString() -- {单挑最佳击破玩家名字}
	self.dt_best_warid = reader:readInt32Unsigned() -- {单挑最佳击破玩家战报id}
	self.zs_best_sid = reader:readInt16Unsigned() -- {正式最佳击破玩家sid}
	self.zs_best_uid = reader:readInt32Unsigned() -- {正式最佳击破玩家uid}
	self.zs_best_uname = reader:readString() -- {正式最佳击破玩家名字}
	self.zs_best_warid = reader:readInt32Unsigned() -- {正式最佳击破玩家战报id}
end

-- {怪物id}
function ACK_KINGHELL_BACK_FIRBEST.getMonsId(self)
	return self.mons_id
end

-- {单挑首次击破玩家sid}
function ACK_KINGHELL_BACK_FIRBEST.getDtFirstSid(self)
	return self.dt_first_sid
end

-- {单挑首次击破玩家uid}
function ACK_KINGHELL_BACK_FIRBEST.getDtFirstUid(self)
	return self.dt_first_uid
end

-- {单挑首次击破玩家名字}
function ACK_KINGHELL_BACK_FIRBEST.getDtFirstUname(self)
	return self.dt_first_uname
end

-- {单挑首次击破玩家战报id}
function ACK_KINGHELL_BACK_FIRBEST.getDtFirstWarid(self)
	return self.dt_first_warid
end

-- {正式首次击破玩家sid}
function ACK_KINGHELL_BACK_FIRBEST.getZsFirstSid(self)
	return self.zs_first_sid
end

-- {正式首次击破玩家uid}
function ACK_KINGHELL_BACK_FIRBEST.getZsFirstUid(self)
	return self.zs_first_uid
end

-- {正式首次击破玩家名字}
function ACK_KINGHELL_BACK_FIRBEST.getZsFirstUname(self)
	return self.zs_first_uname
end

-- {正式首次击破玩家战报id}
function ACK_KINGHELL_BACK_FIRBEST.getZsFirstWarid(self)
	return self.zs_first_warid
end

-- {单挑最佳击破玩家sid}
function ACK_KINGHELL_BACK_FIRBEST.getDtBestSid(self)
	return self.dt_best_sid
end

-- {单挑最佳击破玩家uid}
function ACK_KINGHELL_BACK_FIRBEST.getDtBestUid(self)
	return self.dt_best_uid
end

-- {单挑最佳击破玩家名字}
function ACK_KINGHELL_BACK_FIRBEST.getDtBestUname(self)
	return self.dt_best_uname
end

-- {单挑最佳击破玩家战报id}
function ACK_KINGHELL_BACK_FIRBEST.getDtBestWarid(self)
	return self.dt_best_warid
end

-- {正式最佳击破玩家sid}
function ACK_KINGHELL_BACK_FIRBEST.getZsBestSid(self)
	return self.zs_best_sid
end

-- {正式最佳击破玩家uid}
function ACK_KINGHELL_BACK_FIRBEST.getZsBestUid(self)
	return self.zs_best_uid
end

-- {正式最佳击破玩家名字}
function ACK_KINGHELL_BACK_FIRBEST.getZsBestUname(self)
	return self.zs_best_uname
end

-- {正式最佳击破玩家战报id}
function ACK_KINGHELL_BACK_FIRBEST.getZsBestWarid(self)
	return self.zs_best_warid
end
