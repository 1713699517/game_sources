
require "common/AcknowledgementMessage"

-- [5970]场景广播-改变战斗状态(is_war) -- 场景 

ACK_SCENE_CHANGE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_STATE
	self:init()
end)

function ACK_SCENE_CHANGE_STATE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.state_new = reader:readInt8Unsigned() -- {玩家状态(新)}
end

-- {玩家UID}
function ACK_SCENE_CHANGE_STATE.getUid(self)
	return self.uid
end

-- {玩家状态(新)}
function ACK_SCENE_CHANGE_STATE.getStateNew(self)
	return self.state_new
end
