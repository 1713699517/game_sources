
require "common/RequestMessage"

-- [57820]请求类型 -- 宝箱探秘 

REQ_DISCOVE_STORE_TYPE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DISCOVE_STORE_TYPE
	self:init(0, nil)
end)

function REQ_DISCOVE_STORE_TYPE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:x10道具|2:x100道具}
end

function REQ_DISCOVE_STORE_TYPE.setArguments(self,type)
	self.type = type  -- {1:x10道具|2:x100道具}
end

-- {1:x10道具|2:x100道具}
function REQ_DISCOVE_STORE_TYPE.setType(self, type)
	self.type = type
end
function REQ_DISCOVE_STORE_TYPE.getType(self)
	return self.type
end
