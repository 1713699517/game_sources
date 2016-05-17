
require "common/RequestMessage"

-- [5010]请求进入场景(飞) -- 场景 

REQ_SCENE_ENTER_FLY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_ENTER_FLY
	self:init(0 ,{ 5030,700 })
end)

function REQ_SCENE_ENTER_FLY.serialize(self, writer)
	writer:writeInt32Unsigned(self.map_id)  -- {目的场景地图ID}
end

function REQ_SCENE_ENTER_FLY.setArguments(self,map_id)
	self.map_id = map_id  -- {目的场景地图ID}
end

-- {目的场景地图ID}
function REQ_SCENE_ENTER_FLY.setMapId(self, map_id)
	self.map_id = map_id
end
function REQ_SCENE_ENTER_FLY.getMapId(self)
	return self.map_id
end
