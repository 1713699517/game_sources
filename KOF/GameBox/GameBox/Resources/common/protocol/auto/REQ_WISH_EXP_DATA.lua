
require "common/RequestMessage"

-- [10030]请求祝福经验信息 -- 祝福 

REQ_WISH_EXP_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WISH_EXP_DATA
	self:init(0, nil)
end)
