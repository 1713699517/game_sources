
require "common/RequestMessage"

-- [41530]挑战开始 -- 年兽 

REQ_NIANSHOU_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NIANSHOU_WAR
	self:init(0, nil)
end)
