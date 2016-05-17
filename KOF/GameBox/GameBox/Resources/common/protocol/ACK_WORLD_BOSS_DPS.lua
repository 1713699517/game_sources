
require "common/AcknowledgementMessage"
require "common/protocol/auto/ACK_WORLD_BOSS_DPS_XX"
-- [37060]DPS排行 -- 世界BOSS

ACK_WORLD_BOSS_DPS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WORLD_BOSS_DPS
	self:init()
end)

function ACK_WORLD_BOSS_DPS.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.self_harm = reader:readInt32Unsigned() -- {自己伤害}
	self.count = reader:readInt16Unsigned() -- {数量}
    --self.data = reader:readXXXGroup() -- {信息块(37070)}

    self.data = {}
    for i=1,self.count do
        local tempObject = ACK_WORLD_BOSS_DPS_XX()
        tempObject : deserialize( reader )
        self.data[tempObject : getRank()] = tempObject
    end
end

-- {玩家uid}
function ACK_WORLD_BOSS_DPS.getUid(self)
	return self.uid
end

-- {自己伤害}
function ACK_WORLD_BOSS_DPS.getSelfHarm(self)
	return self.self_harm
end

-- {数量}
function ACK_WORLD_BOSS_DPS.getCount(self)
	return self.count
end

-- {信息块(37070)}
function ACK_WORLD_BOSS_DPS.getData(self)
	return self.data
end
