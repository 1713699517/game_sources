
require "common/RequestMessage"

-- [3210]请求任务列表 -- 任务 

REQ_TASK_REQUEST_LIST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_REQUEST_LIST
	self:init()
end)
