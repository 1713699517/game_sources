
require "common/RequestMessage"

-- (手动) -- [31290]开始斗法 -- 客栈 

REQ_INN_WAR_CONTEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_WAR_CONTEST
	self:init()
end)
