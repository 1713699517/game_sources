
require "common/RequestMessage"

-- [7040]副本计时(待删除) -- 副本 

REQ_COPY_TIMING = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_TIMING
	self:init(0, nil)
end)

function REQ_COPY_TIMING.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {开始或停止计时(详见CONST_COPY_*)}
end

function REQ_COPY_TIMING.setArguments(self,type)
	self.type = type  -- {开始或停止计时(详见CONST_COPY_*)}
end

-- {开始或停止计时(详见CONST_COPY_*)}
function REQ_COPY_TIMING.setType(self, type)
	self.type = type
end
function REQ_COPY_TIMING.getType(self)
	return self.type
end
