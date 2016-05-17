
require "common/RequestMessage"

-- [5170]玩家请求复活 -- 场景 

REQ_SCENE_RELIVE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_RELIVE_REQUEST
	self:init(0 ,{ 5180,700 })
end)
