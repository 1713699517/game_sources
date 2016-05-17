
require "common/AcknowledgementMessage"

-- [5030]进入场景 -- 场景 

ACK_SCENE_ENTER_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_ENTER_OK
	self:init()
end)

function ACK_SCENE_ENTER_OK.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {用户ID}
	self.map_id = reader:readInt16Unsigned() -- {进入的场景}
	self.pos_x = reader:readInt16Unsigned() -- {X}
	self.pos_y = reader:readInt16Unsigned() -- {Y}
	self.speed = reader:readInt16Unsigned() -- {速度}
	self.dir = reader:readInt8Unsigned() -- {方向}
	self.distance = reader:readInt16Unsigned() -- {距离}
	self.enter_type = reader:readInt8Unsigned() -- {类型 1:普通 2:副本 3:瞬移 4:校正}
	self.team_id = reader:readInt32Unsigned() -- {1:组队 0:无组队}
	self.hp_now = reader:readInt32Unsigned() -- {当前血量}
	self.hp_max = reader:readInt32Unsigned() -- {最大血量}
end

-- {用户ID}
function ACK_SCENE_ENTER_OK.getUid(self)
	return self.uid
end

-- {进入的场景}
function ACK_SCENE_ENTER_OK.getMapId(self)
	return self.map_id
end

-- {X}
function ACK_SCENE_ENTER_OK.getPosX(self)
	return self.pos_x
end

-- {Y}
function ACK_SCENE_ENTER_OK.getPosY(self)
	return self.pos_y
end

-- {速度}
function ACK_SCENE_ENTER_OK.getSpeed(self)
	return self.speed
end

-- {方向}
function ACK_SCENE_ENTER_OK.getDir(self)
	return self.dir
end

-- {距离}
function ACK_SCENE_ENTER_OK.getDistance(self)
	return self.distance
end

-- {类型 1:普通 2:副本 3:瞬移 4:校正}
function ACK_SCENE_ENTER_OK.getEnterType(self)
	return self.enter_type
end

-- {1:组队 0:无组队}
function ACK_SCENE_ENTER_OK.getTeamId(self)
	return self.team_id
end

-- {当前血量}
function ACK_SCENE_ENTER_OK.getHpNow(self)
	return self.hp_now
end

-- {最大血量}
function ACK_SCENE_ENTER_OK.getHpMax(self)
	return self.hp_max
end
