
require "common/RequestMessage"

-- [32027]帮好友上香子模块 -- 财神 


REQ_WEAGOD_DATAIL_CENSE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_DATAIL_CENSE
	self:init()
end)

function REQ_WEAGOD_DATAIL_CENSE.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)
end

function REQ_WEAGOD_DATAIL_CENSE.setArguments(self,uid)
	self.uid = uid
end

function REQ_WEAGOD_DATAIL_CENSE.getuid(self, value)
	return self.uid
end
