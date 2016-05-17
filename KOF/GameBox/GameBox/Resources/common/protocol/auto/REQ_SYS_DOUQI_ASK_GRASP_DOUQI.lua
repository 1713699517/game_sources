
require "common/RequestMessage"

-- [48210]请求领悟界面 -- 斗气系统 

REQ_SYS_DOUQI_ASK_GRASP_DOUQI = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_GRASP_DOUQI
	self:init(1 ,{ 48220,700 })
end)
