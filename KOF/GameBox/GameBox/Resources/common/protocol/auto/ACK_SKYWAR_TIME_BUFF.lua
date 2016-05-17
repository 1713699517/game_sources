
require "common/AcknowledgementMessage"

-- [40505]天宫之战暂缓时间戳 -- 天宫之战 

ACK_SKYWAR_TIME_BUFF = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_TIME_BUFF
	self:init()
end)

function ACK_SKYWAR_TIME_BUFF.deserialize(self, reader)
	self.seconds = reader:readInt32Unsigned() -- {天宫之战开始内墙时间戳}
end

-- {天宫之战开始内墙时间戳}
function ACK_SKYWAR_TIME_BUFF.getSeconds(self)
	return self.seconds
end
