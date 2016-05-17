
require "common/AcknowledgementMessage"

-- [1061]销毁角色(成功) -- 角色 

ACK_ROLE_DEL_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_DEL_OK
	self:init()
end)

function ACK_ROLE_DEL_OK.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {用户ID}
end

-- {用户ID}
function ACK_ROLE_DEL_OK.getUid(self)
	return self.uid
end
