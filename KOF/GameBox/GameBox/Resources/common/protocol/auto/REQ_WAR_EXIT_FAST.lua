
require "common/RequestMessage"

-- (手动) -- [6150]快速结束战斗 -- 战斗 

REQ_WAR_EXIT_FAST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_EXIT_FAST
	self:init()
end)
