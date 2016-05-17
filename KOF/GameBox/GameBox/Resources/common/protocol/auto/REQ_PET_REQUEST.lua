
require "common/RequestMessage"

-- [22810]请求宠物列表 -- 宠物 

REQ_PET_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_REQUEST
	self:init(1 ,{ 22820,700 })
end)
