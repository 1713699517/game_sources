
require "common/RequestMessage"

-- (手动) -- [6110]展示战报 -- 战斗 

REQ_WAR_SHOW = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_SHOW
	self:init()
end)
