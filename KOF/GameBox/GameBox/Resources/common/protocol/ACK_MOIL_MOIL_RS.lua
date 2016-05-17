
require "common/AcknowledgementMessage"

-- [35021]苦工操作信息 -- 苦工 

ACK_MOIL_MOIL_RS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_MOIL_RS
	self:init()
end)

-- {时间}
function ACK_MOIL_MOIL_RS.getTime(self)
	return self.time
end

-- {主动方服务器id}
function ACK_MOIL_MOIL_RS.getSid(self)
	return self.sid
end

-- {主动方Uid}
function ACK_MOIL_MOIL_RS.getUid(self)
	return self.uid
end

-- {主动方姓名}
function ACK_MOIL_MOIL_RS.getName(self)
	return self.name
end

-- {被动方服务器id}
function ACK_MOIL_MOIL_RS.getBsid(self)
	return self.bsid
end

-- {被动方Uid}
function ACK_MOIL_MOIL_RS.getBuid(self)
	return self.buid
end

-- {被动方姓名}
function ACK_MOIL_MOIL_RS.getBname(self)
	return self.bname
end

-- {类型：抓捕,互动...}
function ACK_MOIL_MOIL_RS.getType(self)
	return self.type
end

-- {1:成功0:失败}
function ACK_MOIL_MOIL_RS.getRes(self)
	return self.res
end

-- {互动Id}
function ACK_MOIL_MOIL_RS.getActiveId(self)
	return self.active_id
end

-- {互动经验}
function ACK_MOIL_MOIL_RS.getActiveExp(self)
	return self.active_exp
end

-- {1:成功0:失败}
function ACK_MOIL_MOIL_RS.getRes2(self)
	return self.res2
end
