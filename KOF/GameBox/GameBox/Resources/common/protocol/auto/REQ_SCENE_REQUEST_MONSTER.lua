
require "common/RequestMessage"

-- [5060]请求怪物数据 -- 场景 

REQ_SCENE_REQUEST_MONSTER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_REQUEST_MONSTER
	self:init(0 ,{ 5065,700 })
end)
