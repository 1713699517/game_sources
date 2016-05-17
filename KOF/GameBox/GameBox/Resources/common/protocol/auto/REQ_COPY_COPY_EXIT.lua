
require "common/RequestMessage"

-- [7820]退出副本 -- 副本 

REQ_COPY_COPY_EXIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_COPY_EXIT
	self:init(0 ,{ 5030,700 })
end)
