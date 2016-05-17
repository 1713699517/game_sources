
require "common/AcknowledgementMessage"

-- [5090]行走数据(地图广播) -- 场景 

ACK_SCENE_MOVE_RECE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_MOVE_RECE
	self:init()
end)

function ACK_SCENE_MOVE_RECE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型 玩家/怪物/宠物 例:CONST_PLAYER}
	self.uid = reader:readInt32Unsigned() -- {玩家(uid)/怪物/宠物(group_mid) 生成ID}
	self.move_type = reader:readInt8Unsigned() -- {移动方式,见CONST_MAP_MOVE_*}
	self.pos_x = reader:readInt16Unsigned() -- {X}
	self.pos_y = reader:readInt16Unsigned() -- {Y}
	self.owner_uid = reader:readInt32Unsigned() -- {所属者Uid(当为伙伴时)}
	self.time = reader:readInt32Unsigned() -- {时间戳}
end

-- {类型 玩家/怪物/宠物 例:CONST_PLAYER}
function ACK_SCENE_MOVE_RECE.getType(self)
	return self.type
end

-- {玩家(uid)/怪物/宠物(group_mid) 生成ID}
function ACK_SCENE_MOVE_RECE.getUid(self)
	return self.uid
end

-- {移动方式,见CONST_MAP_MOVE_*}
function ACK_SCENE_MOVE_RECE.getMoveType(self)
	return self.move_type
end

-- {X}
function ACK_SCENE_MOVE_RECE.getPosX(self)
	return self.pos_x
end

-- {Y}
function ACK_SCENE_MOVE_RECE.getPosY(self)
	return self.pos_y
end

-- {所属者Uid(当为伙伴时)}
function ACK_SCENE_MOVE_RECE.getOwnerUid(self)
	return self.owner_uid
end

-- {时间戳}
function ACK_SCENE_MOVE_RECE.getTime(self)
	return self.time
end
