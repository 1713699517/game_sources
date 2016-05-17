
require "common/RequestMessage"

-- [28010]请求阵型系统 -- 布阵 

REQ_ARRAY_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARRAY_LIST
	self:init(0, nil)
end)
