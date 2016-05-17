
require "common/RequestMessage"

-- [5200]回城 -- 场景 

REQ_SCENE_ENTER_CITY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_ENTER_CITY
	self:init(0 ,{ 5030,700 })
end)
