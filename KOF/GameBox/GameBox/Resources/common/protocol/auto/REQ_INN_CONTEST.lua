
require "common/RequestMessage"

-- (手动) -- [31185]请求斗法 -- 客栈 

REQ_INN_CONTEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_CONTEST
	self:init()
end)
