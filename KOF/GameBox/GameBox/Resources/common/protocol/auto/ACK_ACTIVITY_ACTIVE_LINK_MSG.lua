
require "common/AcknowledgementMessage"

-- [30630]活动数据信息块 -- 活动面板 

ACK_ACTIVITY_ACTIVE_LINK_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_ACTIVE_LINK_MSG
	self:init()
end)

function ACK_ACTIVITY_ACTIVE_LINK_MSG.deserialize(self, reader)
	self.active_id = reader:readInt16Unsigned() -- {活动入口id}
	self.ok_times = reader:readInt8Unsigned() -- {已 完成次数}
	self.all_times = reader:readInt8Unsigned() -- {应 完成次数}
	self.active_vitality = reader:readInt8Unsigned() -- {完成活动可得活跃度}
end

-- {活动入口id}
function ACK_ACTIVITY_ACTIVE_LINK_MSG.getActiveId(self)
	return self.active_id
end

-- {已 完成次数}
function ACK_ACTIVITY_ACTIVE_LINK_MSG.getOkTimes(self)
	return self.ok_times
end

-- {应 完成次数}
function ACK_ACTIVITY_ACTIVE_LINK_MSG.getAllTimes(self)
	return self.all_times
end

-- {完成活动可得活跃度}
function ACK_ACTIVITY_ACTIVE_LINK_MSG.getActiveVitality(self)
	return self.active_vitality
end
