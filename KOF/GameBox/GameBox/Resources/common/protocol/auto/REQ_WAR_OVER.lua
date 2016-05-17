
require "common/RequestMessage"

-- (手动) -- [6021]战斗结束 -- 战斗 

REQ_WAR_OVER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_OVER
	self:init()
end)
