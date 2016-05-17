
require "common/RequestMessage"

-- [35070]压榨/抽取/提取 -- 苦工 

REQ_MOIL_PRESS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_PRESS
	self:init(0, nil)
end)

function REQ_MOIL_PRESS.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:提取2:压榨3:抽取}
	writer:writeInt32Unsigned(self.uid)  -- {苦工uid}
end

function REQ_MOIL_PRESS.setArguments(self,type,uid)
	self.type = type  -- {1:提取2:压榨3:抽取}
	self.uid = uid  -- {苦工uid}
end

-- {1:提取2:压榨3:抽取}
function REQ_MOIL_PRESS.setType(self, type)
	self.type = type
end
function REQ_MOIL_PRESS.getType(self)
	return self.type
end

-- {苦工uid}
function REQ_MOIL_PRESS.setUid(self, uid)
	self.uid = uid
end
function REQ_MOIL_PRESS.getUid(self)
	return self.uid
end
