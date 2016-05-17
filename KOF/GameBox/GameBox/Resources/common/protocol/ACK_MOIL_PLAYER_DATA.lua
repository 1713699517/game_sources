
require "common/AcknowledgementMessage"

-- [35025]玩家信息列表(抓捕,求救) -- 苦工 

ACK_MOIL_PLAYER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PLAYER_DATA
	self:init()
end)

-- {1:抓捕6:求救(CONST_MOIL_FUNCTION*) (选择)}
function ACK_MOIL_PLAYER_DATA.getType(self)
	return self.type
end

-- {数量}
function ACK_MOIL_PLAYER_DATA.getCount(self)
	return self.count
end

-- {信息块35026}
function ACK_MOIL_PLAYER_DATA.getData(self)
	return self.data
end
