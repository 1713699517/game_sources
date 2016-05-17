
require "common/AcknowledgementMessage"

-- [40502]天宫之战倒计时 -- 天宫之战 

ACK_SKYWAR_TIME_DOWN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_TIME_DOWN
	self:init()
end)

-- {类型(1:离开始|0:离结束)}
function ACK_SKYWAR_TIME_DOWN.getType(self)
	return self.type
end

-- {到点时间戳}
function ACK_SKYWAR_TIME_DOWN.getSeconds(self)
	return self.seconds
end
