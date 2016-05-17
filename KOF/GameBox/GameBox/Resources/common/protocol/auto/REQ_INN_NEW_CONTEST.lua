
require "common/RequestMessage"

-- (手动) -- [31310]新请求斗法 -- 客栈 

REQ_INN_NEW_CONTEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_NEW_CONTEST
	self:init()
end)
