
require "common/AcknowledgementMessage"

-- [37140]加成信息 -- 世界BOSS 

ACK_WORLD_BOSS_ADDITION_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_ADDITION_DATA
	self:init()
end)

function ACK_WORLD_BOSS_ADDITION_DATA.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型}
	self.value = reader:readInt32Unsigned() -- {值}
end

-- {类型}
function ACK_WORLD_BOSS_ADDITION_DATA.getType(self)
	return self.type
end

-- {值}
function ACK_WORLD_BOSS_ADDITION_DATA.getValue(self)
	return self.value
end
