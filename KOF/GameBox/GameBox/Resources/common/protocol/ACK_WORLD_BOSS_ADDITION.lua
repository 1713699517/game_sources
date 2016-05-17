
require "common/AcknowledgementMessage"

-- [37130]随机加成 -- 世界BOSS 

ACK_WORLD_BOSS_ADDITION = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_ADDITION
	self:init()
end)

function ACK_WORLD_BOSS_ADDITION.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.data = reader:readXXXGroup() -- {信息块37140}
end

-- {数量}
function ACK_WORLD_BOSS_ADDITION.getCount(self)
	return self.count
end

-- {信息块37140}
function ACK_WORLD_BOSS_ADDITION.getData(self)
	return self.data
end
