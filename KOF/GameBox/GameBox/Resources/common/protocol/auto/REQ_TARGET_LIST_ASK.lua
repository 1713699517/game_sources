
require "common/RequestMessage"

-- [38005]请求目标数据 -- 目标任务 

REQ_TARGET_LIST_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TARGET_LIST_ASK
	self:init(0, nil)
end)
