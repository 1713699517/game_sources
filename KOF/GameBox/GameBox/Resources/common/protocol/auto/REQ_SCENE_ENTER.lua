
require "common/RequestMessage"

-- [5020]请求进入场景 -- 场景 

REQ_SCENE_ENTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_ENTER
	self:init(0 ,{ 5030,700 })
end)

function REQ_SCENE_ENTER.serialize(self, writer)
	writer:writeInt32Unsigned(self.door_id)  -- {即将进入的传送点Id(登录为0)}
end

function REQ_SCENE_ENTER.setArguments(self,door_id)
	self.door_id = door_id  -- {即将进入的传送点Id(登录为0)}
end

-- {即将进入的传送点Id(登录为0)}
function REQ_SCENE_ENTER.setDoorId(self, door_id)
	self.door_id = door_id
end
function REQ_SCENE_ENTER.getDoorId(self)
	return self.door_id
end
