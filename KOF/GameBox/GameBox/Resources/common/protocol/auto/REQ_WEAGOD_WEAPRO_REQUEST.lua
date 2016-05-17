
require "common/RequestMessage"

-- (手动) -- [32080]财神符面板请求 -- 财神 

REQ_WEAGOD_WEAPRO_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_WEAPRO_REQUEST
	self:init()
end)
