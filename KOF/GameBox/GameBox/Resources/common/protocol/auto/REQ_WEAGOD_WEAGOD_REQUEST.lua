
require "common/RequestMessage"

-- (手动) -- [32005]财神面板请求 -- 财神 

REQ_WEAGOD_WEAGOD_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_WEAGOD_REQUEST
	self:init()
end)
