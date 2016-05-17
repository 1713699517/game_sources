
require "common/AcknowledgementMessage"

-- [5070]怪物数据(刷新) -- 场景 

ACK_SCENE_MONSTER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_MONSTER_DATA
	self:init()
end)

function ACK_SCENE_MONSTER_DATA.deserialize(self, reader)
	self.monster_mid = reader:readInt32Unsigned() -- {怪物生成ID}
	self.monster_id = reader:readInt16Unsigned() -- {怪物ID}
	self.origin_x = reader:readInt16Unsigned() -- {出生X坐标}
	self.origin_y = reader:readInt16Unsigned() -- {出生Y坐标}
	self.speed = reader:readInt16Unsigned() -- {移动速度}
	self.dir = reader:readInt8Unsigned() -- {方向}
	self.now_hp = reader:readInt32Unsigned() -- {当前血量}
	self.max_hp = reader:readInt32Unsigned() -- {最大血量}
end

-- {怪物生成ID}
function ACK_SCENE_MONSTER_DATA.getMonsterMid(self)
	return self.monster_mid
end

-- {怪物ID}
function ACK_SCENE_MONSTER_DATA.getMonsterId(self)
	return self.monster_id
end

-- {出生X坐标}
function ACK_SCENE_MONSTER_DATA.getOriginX(self)
	return self.origin_x
end

-- {出生Y坐标}
function ACK_SCENE_MONSTER_DATA.getOriginY(self)
	return self.origin_y
end

-- {移动速度}
function ACK_SCENE_MONSTER_DATA.getSpeed(self)
	return self.speed
end

-- {方向}
function ACK_SCENE_MONSTER_DATA.getDir(self)
	return self.dir
end

-- {当前血量}
function ACK_SCENE_MONSTER_DATA.getNowHp(self)
	return self.now_hp
end

-- {最大血量}
function ACK_SCENE_MONSTER_DATA.getMaxHp(self)
	return self.max_hp
end
