
require "common/RequestMessage"

-- (手动) -- [4055]请求推荐好友 -- 好友 

REQ_FRIEND_REQUEST_RECOM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_REQUEST_RECOM
	self:init()
end)
