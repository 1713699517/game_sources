
require "common/AcknowledgementMessage"

-- (手动) -- [1002]踢人下线 -- 角色 

ACK_ROLE_OUT2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OUT2
	self:init()
end)

function ACK_ROLE_OUT2.deserialize(self, reader)
	self.msg = reader:readUTF() -- {提示信息}
end

-- {提示信息}
function ACK_ROLE_OUT2.getMsg(self)
	return self.msg
end
