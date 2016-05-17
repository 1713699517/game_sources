
require "common/AcknowledgementMessage"

-- [1311]请求vip回复 -- 角色 

ACK_ROLE_LV_MY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LV_MY
	self:init()
end)

function ACK_ROLE_LV_MY.deserialize(self, reader)
	self.lv = reader:readInt8Unsigned() -- {自己的vip等级}
	self.vip_up = reader:readInt32() -- {已购买金元总数}
end

-- {自己的vip等级}
function ACK_ROLE_LV_MY.getLv(self)
	return self.lv
end

-- {已购买金元总数}
function ACK_ROLE_LV_MY.getVipUp(self)
	return self.vip_up
end
