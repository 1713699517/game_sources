
require "common/AcknowledgementMessage"

-- (手动) -- [5045]玩家信息列表 -- 场景

ACK_SCENE_PLAYER_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_PLAYER_LIST
	self:init()
end)

function ACK_SCENE_PLAYER_LIST.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {地图玩家数量}
	--self.data = reader:readXXXGroup() -- {玩家信息块(5050)}
    require "common/protocol/auto/ACK_SCENE_ROLE_DATA"
    self.data = {}
    for i=1,self.count do
        self.data[i] = ACK_SCENE_ROLE_DATA()
        self.data[i] : deserialize( reader )
    end
end

-- {地图玩家数量}
function ACK_SCENE_PLAYER_LIST.getCount(self)
	return self.count
end

-- {玩家信息块(5050)}
function ACK_SCENE_PLAYER_LIST.getData(self)
	return self.data
end
