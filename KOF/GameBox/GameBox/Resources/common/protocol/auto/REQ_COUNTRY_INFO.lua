
require "common/RequestMessage"

-- [14001]请求阵营信息 -- 阵营 

REQ_COUNTRY_INFO = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COUNTRY_INFO
	self:init(0, nil)
end)
