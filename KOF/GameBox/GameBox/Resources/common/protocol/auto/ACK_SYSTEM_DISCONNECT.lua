
require "common/AcknowledgementMessage"

-- [502]服务器将断开连接 -- 系统 

ACK_SYSTEM_DISCONNECT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_DISCONNECT
	self:init()
end)

function ACK_SYSTEM_DISCONNECT.deserialize(self, reader)
	self.error_code = reader:readInt16Unsigned() -- {错误代码}
	self.msg = reader:readUTF() -- {提示信息}
end

-- {错误代码}
function ACK_SYSTEM_DISCONNECT.getErrorCode(self)
	return self.error_code
end

-- {提示信息}
function ACK_SYSTEM_DISCONNECT.getMsg(self)
	return self.msg
end
