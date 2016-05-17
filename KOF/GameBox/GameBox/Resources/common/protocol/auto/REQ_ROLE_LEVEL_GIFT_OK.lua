
require "common/RequestMessage"

-- [1351]领取等级礼包 -- 角色 

REQ_ROLE_LEVEL_GIFT_OK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_LEVEL_GIFT_OK
	self:init(0, nil)
end)
