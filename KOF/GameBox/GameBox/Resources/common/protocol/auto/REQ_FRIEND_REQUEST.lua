
require "common/RequestMessage"

-- (手动) -- [4004]请求关系信息 -- 好友 

REQ_FRIEND_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_REQUEST
	self:init()
end)
