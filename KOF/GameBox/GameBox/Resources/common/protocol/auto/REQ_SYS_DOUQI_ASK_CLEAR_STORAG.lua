
require "common/RequestMessage"

-- [48400]请求整理仓库 [48201] Type=1 -- 斗气系统 

REQ_SYS_DOUQI_ASK_CLEAR_STORAG = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_CLEAR_STORAG
	self:init(0, nil)
end)
