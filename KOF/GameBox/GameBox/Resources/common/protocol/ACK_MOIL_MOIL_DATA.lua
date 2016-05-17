
require "common/AcknowledgementMessage"

-- [35020]返回自己身份信息 -- 苦工 

ACK_MOIL_MOIL_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOIL_MOIL_DATA
	self:init()
end)

-- {身份Id}
function ACK_MOIL_MOIL_DATA.getTypeId(self)
	return self.type_id
end

-- {主人sid}
function ACK_MOIL_MOIL_DATA.getLSid(self)
	return self.l_sid
end

-- {主人uid}
function ACK_MOIL_MOIL_DATA.getLUid(self)
	return self.l_uid
end

-- {主人名字}
function ACK_MOIL_MOIL_DATA.getLName(self)
	return self.l_name
end

-- {主人等级}
function ACK_MOIL_MOIL_DATA.getLLv(self)
	return self.l_lv
end

-- {抓捕次数}
function ACK_MOIL_MOIL_DATA.getCaptrueCount(self)
	return self.captrue_count
end

-- {互动次数}
function ACK_MOIL_MOIL_DATA.getActiveCount(self)
	return self.active_count
end

-- {求救次数}
function ACK_MOIL_MOIL_DATA.getCallsCount(self)
	return self.calls_count
end

-- {反抗次数}
function ACK_MOIL_MOIL_DATA.getProtestCount(self)
	return self.protest_count
end

-- {当前经验}
function ACK_MOIL_MOIL_DATA.getExpn(self)
	return self.expn
end

-- {经验上限}
function ACK_MOIL_MOIL_DATA.getExp(self)
	return self.exp
end

-- {数量}
function ACK_MOIL_MOIL_DATA.getCount(self)
	return self.count
end

-- {信息块 35021}
function ACK_MOIL_MOIL_DATA.getData(self)
	return self.data
end
