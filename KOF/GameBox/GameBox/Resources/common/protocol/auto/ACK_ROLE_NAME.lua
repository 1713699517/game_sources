
require "common/AcknowledgementMessage"

-- [1025]返回名字 -- 角色 

ACK_ROLE_NAME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_NAME
	self:init()
end)

function ACK_ROLE_NAME.deserialize(self, reader)
	self.name = reader:readUTF() -- {名字}
end

-- {名字}
function ACK_ROLE_NAME.getName(self)
	return self.name
end
