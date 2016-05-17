
require "common/AcknowledgementMessage"

-- [5960]场景广播--改变坐骑 -- 场景 

ACK_SCENE_CHANGE_MOUNT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_MOUNT
	self:init()
end)

function ACK_SCENE_CHANGE_MOUNT.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.mount = reader:readInt16Unsigned() -- {坐骑}
	self.speed = reader:readInt16Unsigned() -- {速度}
end

-- {玩家uid}
function ACK_SCENE_CHANGE_MOUNT.getUid(self)
	return self.uid
end

-- {坐骑}
function ACK_SCENE_CHANGE_MOUNT.getMount(self)
	return self.mount
end

-- {速度}
function ACK_SCENE_CHANGE_MOUNT.getSpeed(self)
	return self.speed
end
