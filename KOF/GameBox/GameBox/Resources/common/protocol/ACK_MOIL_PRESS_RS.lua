
require "common/AcknowledgementMessage"

-- [35080] 压榨结果 -- 苦工 

ACK_MOIL_PRESS_RS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_PRESS_RS
	self:init()
end)

-- {1:提取2:压榨3:抽取 (选择)}
function ACK_MOIL_PRESS_RS.getType(self)
	return self.type
end

-- {剩下的时间}
function ACK_MOIL_PRESS_RS.getTime(self)
	return self.time
end

-- {苦工sid}
function ACK_MOIL_PRESS_RS.getSid(self)
	return self.sid
end

-- {苦工uid}
function ACK_MOIL_PRESS_RS.getUid(self)
	return self.uid
end

-- {数量}
function ACK_MOIL_PRESS_RS.getCount(self)
	return self.count
end

-- {信息块35081}
function ACK_MOIL_PRESS_RS.getData(self)
	return self.data
end
