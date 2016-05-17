
require "common/AcknowledgementMessage"

-- [5110]离开场景 -- 场景 

ACK_SCENE_OUT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_OUT
	self:init()
end)

function ACK_SCENE_OUT.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型  玩家/怪物/宠物 例:CONST_PLAYER}
	self.uid = reader:readInt32Unsigned() -- {玩家uid/怪物/宠物monster_mid 生成ID}
	self.out_type = reader:readInt8Unsigned() -- {离开玩家视野/怪物/玩家/宝宝被杀死亡/瞬移走了}
	self.owner_uid = reader:readInt32Unsigned() -- {所属者Uid(当为伙伴时)}
end

-- {类型  玩家/怪物/宠物 例:CONST_PLAYER}
function ACK_SCENE_OUT.getType(self)
	return self.type
end

-- {玩家uid/怪物/宠物monster_mid 生成ID}
function ACK_SCENE_OUT.getUid(self)
	return self.uid
end

-- {离开玩家视野/怪物/玩家/宝宝被杀死亡/瞬移走了}
function ACK_SCENE_OUT.getOutType(self)
	return self.out_type
end

-- {所属者Uid(当为伙伴时)}
function ACK_SCENE_OUT.getOwnerUid(self)
	return self.owner_uid
end
