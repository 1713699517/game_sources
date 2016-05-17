
require "common/AcknowledgementMessage"

-- (手动) -- [5052]地图伙伴列表 -- 场景

ACK_SCENE_PARTNER_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_PARTNER_LIST
	self:init()
end)

function ACK_SCENE_PARTNER_LIST.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {伙伴数量}
	--self.data = reader:readXXXGroup() -- {伙伴信息块(5055)}
    require "common/protocol/auto/ACK_SCENE_PARTNER_DATA"
    self.data = {}
    for i=1,self.count do
        self.data[i] = ACK_SCENE_PARTNER_DATA()
        self.data[i] : deserialize( reader )
    end
end

-- {伙伴数量}
function ACK_SCENE_PARTNER_LIST.getCount(self)
	return self.count
end

-- {伙伴信息块(5055)}
function ACK_SCENE_PARTNER_LIST.getData(self)
	return self.data
end
