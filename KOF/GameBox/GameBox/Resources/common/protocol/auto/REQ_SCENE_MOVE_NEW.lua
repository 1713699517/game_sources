
require "common/RequestMessage"

-- [5085]行走数据(广播) -- 场景 

REQ_SCENE_MOVE_NEW = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_MOVE_NEW
	self:init(0, nil)
end)

function REQ_SCENE_MOVE_NEW.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {类型 玩家/怪物/宠物 例:CONST_PLAYER}
	writer:writeInt32Unsigned(self.uid)  -- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
	writer:writeInt8Unsigned(self.move_type)  -- {移动方式,见CONST_MAP_MOVE_*}
	writer:writeInt16Unsigned(self.pos_x)  -- {x}
	writer:writeInt16Unsigned(self.pos_y)  -- {y}
end

function REQ_SCENE_MOVE_NEW.setArguments(self,type,uid,move_type,pos_x,pos_y)
	self.type = type  -- {类型 玩家/怪物/宠物 例:CONST_PLAYER}
	self.uid = uid  -- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
	self.move_type = move_type  -- {移动方式,见CONST_MAP_MOVE_*}
	self.pos_x = pos_x  -- {x}
	self.pos_y = pos_y  -- {y}
end

-- {类型 玩家/怪物/宠物 例:CONST_PLAYER}
function REQ_SCENE_MOVE_NEW.setType(self, type)
	self.type = type
end
function REQ_SCENE_MOVE_NEW.getType(self)
	return self.type
end

-- {玩家(uid)/怪物/宠物(monster_mid) 生成ID}
function REQ_SCENE_MOVE_NEW.setUid(self, uid)
	self.uid = uid
end
function REQ_SCENE_MOVE_NEW.getUid(self)
	return self.uid
end

-- {移动方式,见CONST_MAP_MOVE_*}
function REQ_SCENE_MOVE_NEW.setMoveType(self, move_type)
	self.move_type = move_type
end
function REQ_SCENE_MOVE_NEW.getMoveType(self)
	return self.move_type
end

-- {x}
function REQ_SCENE_MOVE_NEW.setPosX(self, pos_x)
	self.pos_x = pos_x
end
function REQ_SCENE_MOVE_NEW.getPosX(self)
	return self.pos_x
end

-- {y}
function REQ_SCENE_MOVE_NEW.setPosY(self, pos_y)
	self.pos_y = pos_y
end
function REQ_SCENE_MOVE_NEW.getPosY(self)
	return self.pos_y
end
