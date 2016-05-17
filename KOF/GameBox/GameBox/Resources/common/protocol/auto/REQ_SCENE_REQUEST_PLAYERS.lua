
require "common/RequestMessage"

-- [5040]请求场景内玩家信息列表 -- 场景 

REQ_SCENE_REQUEST_PLAYERS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_REQUEST_PLAYERS
	self:init(0 ,{ 5050,5055,700 })
end)
