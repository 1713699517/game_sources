
require "common/RequestMessage"

-- [22102] 请求声望面板 -- 声望 

REQ_RENOWN_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_RENOWN_REQUEST
	self:init(0, nil)
end)
