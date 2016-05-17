
require "common/AcknowledgementMessage"

-- [1313]玩家VIP等级 -- 角色 

ACK_ROLE_VIP_LV = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_VIP_LV
	self:init()
end)

function ACK_ROLE_VIP_LV.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.lv = reader:readInt8Unsigned() -- {vip等级}
end

-- {玩家UID}
function ACK_ROLE_VIP_LV.getUid(self)
	return self.uid
end

-- {vip等级}
function ACK_ROLE_VIP_LV.getLv(self)
	return self.lv
end
