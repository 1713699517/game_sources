
require "common/RequestMessage"

-- [7864]请求登陆挂机 -- 副本 

REQ_COPY_IS_UP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_IS_UP
	self:init(0, nil)
end)
