
require "common/RequestMessage"

-- [48230]请求装备斗气界面 -- 斗气系统 

REQ_SYS_DOUQI_ASK_USR_GRASP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_USR_GRASP
	self:init(1 ,{ 48240,700 })
end)
