
require "common/RequestMessage"

-- [22830]开启式神 -- 宠物 

REQ_PET_OPEN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_OPEN
	self:init(0, nil)
end)
