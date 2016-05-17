
require "common/RequestMessage"

-- (手动) -- [22970]宠物栏开格 -- 宠物 

REQ_PET_CTN_ENLARGE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_CTN_ENLARGE
	self:init()
end)
