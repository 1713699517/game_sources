
require "common/AcknowledgementMessage"

-- [9020]防沉迷提示 -- 防沉迷 

ACK_FCM_PROMPT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FCM_PROMPT
	self:init()
end)

function ACK_FCM_PROMPT.deserialize(self, reader)
	self.show = reader:readBoolean() -- {是否显示(true:显示;false:不显示)}
	self.state = reader:readInt8Unsigned() -- {防沉迷状态 0:正常 1:收益减半 2:收益为0}
	self.time = reader:readInt32Unsigned() -- {上网时长(秒)}
end

-- {是否显示(true:显示;false:不显示)}
function ACK_FCM_PROMPT.getShow(self)
	return self.show
end

-- {防沉迷状态 0:正常 1:收益减半 2:收益为0}
function ACK_FCM_PROMPT.getState(self)
	return self.state
end

-- {上网时长(秒)}
function ACK_FCM_PROMPT.getTime(self)
	return self.time
end
