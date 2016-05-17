
require "common/AcknowledgementMessage"

-- (手动) -- [39015]战役数据信息块 -- 取经之路 

ACK_PILROAD_MSG_BATTLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_MSG_BATTLE
	self:init()
end)

function ACK_PILROAD_MSG_BATTLE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.is_in = reader:readInt8Unsigned() -- {是否可以进入(1：可以 0：不可以)}
end

-- {副本ID}
function ACK_PILROAD_MSG_BATTLE.getCopyId(self)
	return self.copy_id
end

-- {是否可以进入(1：可以 0：不可以)}
function ACK_PILROAD_MSG_BATTLE.getIsIn(self)
	return self.is_in
end
