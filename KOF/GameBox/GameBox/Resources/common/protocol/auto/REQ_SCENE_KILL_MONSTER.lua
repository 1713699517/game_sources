
require "common/RequestMessage"

-- [5130]击杀怪物 -- 场景 

REQ_SCENE_KILL_MONSTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_KILL_MONSTER
	self:init(0, nil)
end)

function REQ_SCENE_KILL_MONSTER.serialize(self, writer)
	writer:writeInt32Unsigned(self.monster_mid)  -- {怪物生成ID}
end

function REQ_SCENE_KILL_MONSTER.setArguments(self,monster_mid)
	self.monster_mid = monster_mid  -- {怪物生成ID}
end

-- {怪物生成ID}
function REQ_SCENE_KILL_MONSTER.setMonsterMid(self, monster_mid)
	self.monster_mid = monster_mid
end
function REQ_SCENE_KILL_MONSTER.getMonsterMid(self)
	return self.monster_mid
end
