
require "common/RequestMessage"

-- [53210]新手特权面板请求 -- 新手特权 

REQ_PRIVILEGE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PRIVILEGE_REQUEST
	self:init(0, nil)
end)
