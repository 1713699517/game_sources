
require "common/AcknowledgementMessage"

-- (手动) -- [54945]决赛信息块 -- 格斗之王 

ACK_WRESTLE_FINAL_REP_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_FINAL_REP_MSG
	self:init()
end)

function ACK_WRESTLE_FINAL_REP_MSG.deserialize(self, reader)
	self.index = reader:readInt16Unsigned() -- {位置索引}
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {玩家名字}
	self.is_fail = reader:readInt8Unsigned() -- {是否失败过}
end

-- {位置索引}
function ACK_WRESTLE_FINAL_REP_MSG.getIndex(self)
	return self.index
end

-- {玩家uid}
function ACK_WRESTLE_FINAL_REP_MSG.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_WRESTLE_FINAL_REP_MSG.getName(self)
	return self.name
end

-- {是否失败过}
function ACK_WRESTLE_FINAL_REP_MSG.getIsFail(self)
	return self.is_fail
end
