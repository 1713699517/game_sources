
require "common/RequestMessage"

-- [5042]请求场景玩家列表(new) -- 场景 

REQ_SCENE_REQ_PLAYERS_NEW = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_REQ_PLAYERS_NEW
	self:init(0.5 ,{ 5045,5052,700 })
end)
