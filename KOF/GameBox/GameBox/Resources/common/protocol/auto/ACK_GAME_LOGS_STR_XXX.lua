
require "common/AcknowledgementMessage"

-- [22781]字符串信息块 -- 日志 

ACK_GAME_LOGS_STR_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GAME_LOGS_STR_XXX
	self:init()
end)

function ACK_GAME_LOGS_STR_XXX.deserialize(self, reader)
	self.type1 = reader:readString() -- {字符串}
	self.colour = reader:readInt16Unsigned() -- {}
end

-- {字符串}
function ACK_GAME_LOGS_STR_XXX.getType1(self)
	return self.type1
end

-- {}
function ACK_GAME_LOGS_STR_XXX.getColour(self)
	return self.colour
end
