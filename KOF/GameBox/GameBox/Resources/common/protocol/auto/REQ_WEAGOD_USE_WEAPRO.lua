
require "common/RequestMessage"

-- (手动) -- [32090]使用财神符 -- 财神 

REQ_WEAGOD_USE_WEAPRO = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_USE_WEAPRO
	self:init()
end)
