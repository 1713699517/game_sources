
require "common/AcknowledgementMessage"

-- [22782]数字信息块 -- 日志 

ACK_GAME_LOGS_INT_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GAME_LOGS_INT_XXX
	self:init()
end)

function ACK_GAME_LOGS_INT_XXX.deserialize(self, reader)
	self.type2 = reader:readInt32Unsigned() -- {数据}
end

-- {数据}
function ACK_GAME_LOGS_INT_XXX.getType2(self)
	return self.type2
end
