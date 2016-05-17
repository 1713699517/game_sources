
require "common/RequestMessage"

-- [35040]抓捕 -- 苦工 

REQ_MOIL_CAPTRUE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_CAPTRUE
	self:init(0, nil)
end)

function REQ_MOIL_CAPTRUE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*)}
	writer:writeInt32Unsigned(self.uid)  -- {被抓uid}
end

function REQ_MOIL_CAPTRUE.setArguments(self,type,uid)
	self.type = type  -- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*)}
	self.uid = uid  -- {被抓uid}
end

-- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*)}
function REQ_MOIL_CAPTRUE.setType(self, type)
	self.type = type
end
function REQ_MOIL_CAPTRUE.getType(self)
	return self.type
end

-- {被抓uid}
function REQ_MOIL_CAPTRUE.setUid(self, uid)
	self.uid = uid
end
function REQ_MOIL_CAPTRUE.getUid(self)
	return self.uid
end
