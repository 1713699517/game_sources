
require "common/RequestMessage"

-- (手动) -- [4045]请求是否可以推荐好友 -- 好友 

REQ_FRIEND_CAN_RECOM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_CAN_RECOM
	self:init()
end)
