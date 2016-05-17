
require "common/AcknowledgementMessage"

-- [36022]当前信息块(新) -- 三界杀 

ACK_CIRCLE_2_DATA_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CIRCLE_2_DATA_GROUP
	self:init()
end)

function ACK_CIRCLE_2_DATA_GROUP.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {武将ID}
	self.idx = reader:readInt8Unsigned() -- {位置}
	self.stata = reader:readInt8Unsigned() -- {是否可以挑战}
	self.is_one = reader:readInt8Unsigned() -- {是否第一次挑战}
	self.is_rs = reader:readInt8Unsigned() -- {是否可重置}
	self.best_sid = reader:readInt16Unsigned() -- {最佳玩家sid}
	self.best_uid = reader:readInt32Unsigned() -- {最佳玩家uid}
	self.best_name = reader:readString() -- {最佳玩家名字}
	self.bets_war_id = reader:readInt32Unsigned() -- {最佳玩家战报ID}
	self.first_sid = reader:readInt16Unsigned() -- {首次击杀玩家sid}
	self.first_uid = reader:readInt32Unsigned() -- {首次击杀玩家uid}
	self.first_name = reader:readString() -- {首次击杀玩家名字}
	self.first_war_id = reader:readInt32Unsigned() -- {首次击杀玩家战报ID}
end

-- {武将ID}
function ACK_CIRCLE_2_DATA_GROUP.getId(self)
	return self.id
end

-- {位置}
function ACK_CIRCLE_2_DATA_GROUP.getIdx(self)
	return self.idx
end

-- {是否可以挑战}
function ACK_CIRCLE_2_DATA_GROUP.getStata(self)
	return self.stata
end

-- {是否第一次挑战}
function ACK_CIRCLE_2_DATA_GROUP.getIsOne(self)
	return self.is_one
end

-- {是否可重置}
function ACK_CIRCLE_2_DATA_GROUP.getIsRs(self)
	return self.is_rs
end

-- {最佳玩家sid}
function ACK_CIRCLE_2_DATA_GROUP.getBestSid(self)
	return self.best_sid
end

-- {最佳玩家uid}
function ACK_CIRCLE_2_DATA_GROUP.getBestUid(self)
	return self.best_uid
end

-- {最佳玩家名字}
function ACK_CIRCLE_2_DATA_GROUP.getBestName(self)
	return self.best_name
end

-- {最佳玩家战报ID}
function ACK_CIRCLE_2_DATA_GROUP.getBetsWarId(self)
	return self.bets_war_id
end

-- {首次击杀玩家sid}
function ACK_CIRCLE_2_DATA_GROUP.getFirstSid(self)
	return self.first_sid
end

-- {首次击杀玩家uid}
function ACK_CIRCLE_2_DATA_GROUP.getFirstUid(self)
	return self.first_uid
end

-- {首次击杀玩家名字}
function ACK_CIRCLE_2_DATA_GROUP.getFirstName(self)
	return self.first_name
end

-- {首次击杀玩家战报ID}
function ACK_CIRCLE_2_DATA_GROUP.getFirstWarId(self)
	return self.first_war_id
end
