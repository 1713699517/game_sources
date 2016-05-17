
require "common/AcknowledgementMessage"

-- [5100]强设玩家坐标 -- 场景 

ACK_SCENE_SET_PLAYER_XY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_SET_PLAYER_XY
	self:init()
end)

function ACK_SCENE_SET_PLAYER_XY.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.pos_x = reader:readInt16Unsigned() -- {X坐标}
	self.pos_y = reader:readInt16Unsigned() -- {Y坐标}
end

-- {玩家Uid}
function ACK_SCENE_SET_PLAYER_XY.getUid(self)
	return self.uid
end

-- {X坐标}
function ACK_SCENE_SET_PLAYER_XY.getPosX(self)
	return self.pos_x
end

-- {Y坐标}
function ACK_SCENE_SET_PLAYER_XY.getPosY(self)
	return self.pos_y
end
