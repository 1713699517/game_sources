
require "common/RequestMessage"

-- (手动) -- [32065]财神成长记录请求 -- 财神 

REQ_WEAGOD_GROW_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_GROW_REQUEST
	self:init()
end)
