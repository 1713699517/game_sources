
require "common/AcknowledgementMessage"

-- [5940]场景广播-升级 -- 场景 

ACK_SCENE_LEVEL_UP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_LEVEL_UP
	self:init()
end)

function ACK_SCENE_LEVEL_UP.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {角色Id}
	self.level = reader:readInt16Unsigned() -- {等级}
end

-- {角色Id}
function ACK_SCENE_LEVEL_UP.getUid(self)
	return self.uid
end

-- {等级}
function ACK_SCENE_LEVEL_UP.getLevel(self)
	return self.level
end
