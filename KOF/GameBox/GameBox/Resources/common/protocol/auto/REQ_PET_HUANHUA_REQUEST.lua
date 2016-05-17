
require "common/RequestMessage"

-- [23000]请求幻化界面 -- 宠物 

REQ_PET_HUANHUA_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_HUANHUA_REQUEST
	self:init(1 ,{ 23010,700 })
end)
