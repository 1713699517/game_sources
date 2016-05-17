
require "common/RequestMessage"

-- (手动) -- [32015]可上香好友请求 -- 财神 

REQ_WEAGOD_CEN_FRIEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_CEN_FRIEND
	self:init()
end)
