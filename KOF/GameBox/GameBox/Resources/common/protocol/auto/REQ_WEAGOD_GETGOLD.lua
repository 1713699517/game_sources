
require "common/RequestMessage"

-- (手动) -- [32055]招财 -- 财神 

REQ_WEAGOD_GETGOLD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_GETGOLD
	self:init()
end)

function REQ_WEAGOD_GETGOLD.serialize(self, writer)
	writer:writeInt8Unsigned(self.qkgold)  -- {是否一键招财(1：是 | 0：否)}
end

function REQ_WEAGOD_GETGOLD.setArguments(self,qkgold)
	self.qkgold = qkgold  -- {是否一键招财(1：是 | 0：否)}
end

-- {是否一键招财(1：是 | 0：否)}
function REQ_WEAGOD_GETGOLD.setQkgold(self, qkgold)
	self.qkgold = qkgold
end
function REQ_WEAGOD_GETGOLD.getQkgold(self)
	return self.qkgold
end
