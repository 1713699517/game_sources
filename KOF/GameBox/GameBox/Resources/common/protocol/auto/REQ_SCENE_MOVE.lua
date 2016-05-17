
require "common/RequestMessage"

-- [5080]行走数据 -- 场景 

REQ_SCENE_MOVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_MOVE
	self:init(0, nil)
end)

function REQ_SCENE_MOVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {类型  玩家/怪物/宠物 例:CONST_PLAYER}
	writer:writeInt32Unsigned(self.uid)  -- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
	writer:writeInt8Unsigned(self.move_type)  -- {移动方式,见CONST_MAP_MOVE_*}
	writer:writeInt16Unsigned(self.pos_x)  -- {X}
	writer:writeInt16Unsigned(self.pos_y)  -- {Y}
end

function REQ_SCENE_MOVE.setArguments(self,type,uid,move_type,pos_x,pos_y)
	self.type = type  -- {类型  玩家/怪物/宠物 例:CONST_PLAYER}
	self.uid = uid  -- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
	self.move_type = move_type  -- {移动方式,见CONST_MAP_MOVE_*}
	self.pos_x = pos_x  -- {X}
	self.pos_y = pos_y  -- {Y}
end

-- {类型  玩家/怪物/宠物 例:CONST_PLAYER}
function REQ_SCENE_MOVE.setType(self, type)
	self.type = type
end
function REQ_SCENE_MOVE.getType(self)
	return self.type
end

-- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
function REQ_SCENE_MOVE.setUid(self, uid)
	self.uid = uid
end
function REQ_SCENE_MOVE.getUid(self)
	return self.uid
end

-- {移动方式,见CONST_MAP_MOVE_*}
function REQ_SCENE_MOVE.setMoveType(self, move_type)
	self.move_type = move_type
end
function REQ_SCENE_MOVE.getMoveType(self)
	return self.move_type
end

-- {X}
function REQ_SCENE_MOVE.setPosX(self, pos_x)
	self.pos_x = pos_x
end
function REQ_SCENE_MOVE.getPosX(self)
	return self.pos_x
end

-- {Y}
function REQ_SCENE_MOVE.setPosY(self, pos_y)
	self.pos_y = pos_y
end
function REQ_SCENE_MOVE.getPosY(self)
	return self.pos_y
end
