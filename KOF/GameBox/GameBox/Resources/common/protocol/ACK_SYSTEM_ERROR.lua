
require "common/AcknowledgementMessage"

-- [700]错误代码 -- 系统 

ACK_SYSTEM_ERROR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_ERROR
	self:init()
end)

function ACK_SYSTEM_ERROR.deserialize(self, reader)
	self.error_code = reader:readInt16Unsigned()
end

-- {错误代码}
function ACK_SYSTEM_ERROR.getErrorCode(self)
	return self.error_code
end

-- {错误参数数理}
function ACK_SYSTEM_ERROR.getArgCount(self)
	return self.arg_count
end

-- {参数类型(false:整数 true:字符串)}
function ACK_SYSTEM_ERROR.getArgTypeSelect(self)
	return self.arg_type_select
end

-- {参数数据}
function ACK_SYSTEM_ERROR.getArgData(self)
	return self.arg_data
end

-- {参数数据}
function ACK_SYSTEM_ERROR.getArgData2(self)
	return self.arg_data2
end
