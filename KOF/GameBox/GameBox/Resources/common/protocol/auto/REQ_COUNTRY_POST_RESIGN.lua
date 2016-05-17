
require "common/RequestMessage"

-- [14070]官员辞职 -- 阵营 

REQ_COUNTRY_POST_RESIGN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_POST_RESIGN
	self:init(0, nil)
end)
