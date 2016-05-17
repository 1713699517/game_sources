
require "common/RequestMessage"

-- [12150]培养 -- 坐骑 

REQ_MOUNT_CUL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_CUL
	self:init(0, nil)
end)

function REQ_MOUNT_CUL.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {培养类型(1：银元 2：金元)}
	writer:writeInt16Unsigned(self.num)  -- {培养次数}
end

function REQ_MOUNT_CUL.setArguments(self,type,num)
	self.type = type  -- {培养类型(1：银元 2：金元)}
	self.num = num  -- {培养次数}
end

-- {培养类型(1：银元 2：金元)}
function REQ_MOUNT_CUL.setType(self, type)
	self.type = type
end
function REQ_MOUNT_CUL.getType(self)
	return self.type
end

-- {培养次数}
function REQ_MOUNT_CUL.setNum(self, num)
	self.num = num
end
function REQ_MOUNT_CUL.getNum(self)
	return self.num
end
