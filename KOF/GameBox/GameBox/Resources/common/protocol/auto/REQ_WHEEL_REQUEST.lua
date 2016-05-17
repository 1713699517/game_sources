
require "common/RequestMessage"

-- [46020]请求转盘数据 -- 幸运大转盘 

REQ_WHEEL_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WHEEL_REQUEST
	self:init(0, nil)
end)
