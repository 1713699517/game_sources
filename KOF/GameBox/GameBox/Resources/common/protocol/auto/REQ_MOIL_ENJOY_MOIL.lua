
require "common/RequestMessage"

-- [35010]进入苦工系统 -- 苦工 

REQ_MOIL_ENJOY_MOIL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_ENJOY_MOIL
	self:init(0, nil)
end)
