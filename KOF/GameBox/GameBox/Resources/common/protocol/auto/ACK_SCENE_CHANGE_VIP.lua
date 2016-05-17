
require "common/AcknowledgementMessage"

-- [5980]场景广播-VIP -- 场景 

ACK_SCENE_CHANGE_VIP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_VIP
	self:init()
end)

function ACK_SCENE_CHANGE_VIP.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.viplv = reader:readInt16Unsigned() -- {VIP等级}
end

-- {玩家UID}
function ACK_SCENE_CHANGE_VIP.getUid(self)
	return self.uid
end

-- {VIP等级}
function ACK_SCENE_CHANGE_VIP.getViplv(self)
	return self.viplv
end
