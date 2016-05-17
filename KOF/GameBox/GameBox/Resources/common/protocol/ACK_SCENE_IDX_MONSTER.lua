
require "common/AcknowledgementMessage"
require "common/protocol/ACK_SCENE_MONSTER_DATA"
-- [5065]场景刷出第几波怪 -- 场景

ACK_SCENE_IDX_MONSTER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_IDX_MONSTER
	self:init()
end)

function ACK_SCENE_IDX_MONSTER.deserialize(self, reader)
	self.idx = reader:readInt16Unsigned() -- {第几波}
	self.count = reader:readInt16Unsigned() -- {怪物数量}
	--self.data = reader:readXXXGroup() -- {5070}
    self.data = {}
    for i=1,self.count do
        self.data[i] = ACK_SCENE_MONSTER_DATA()
        self.data[i] : deserialize( reader )
    end
end

-- {第几波}
function ACK_SCENE_IDX_MONSTER.getIdx(self)
	return self.idx
end

-- {怪物数量}
function ACK_SCENE_IDX_MONSTER.getCount(self)
	return self.count
end

-- {5070}
function ACK_SCENE_IDX_MONSTER.getData(self)
	return self.data
end
