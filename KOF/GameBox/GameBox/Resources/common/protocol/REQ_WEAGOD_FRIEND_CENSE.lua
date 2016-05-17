
require "common/RequestMessage"

-- [32035]帮好友上香 -- 财神 


REQ_WEAGOD_FRIEND_CENSE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_FRIEND_CENSE
	self:init()
end)

function REQ_WEAGOD_FRIEND_CENSE.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)
	writer:writeXXXGroup(self.dataildata)
end

function REQ_WEAGOD_FRIEND_CENSE.setArguments(self,count,dataildata)
	self.count = count
	self.dataildata = dataildata
end

function REQ_WEAGOD_FRIEND_CENSE.getcount(self, value)
	return self.count
end

function REQ_WEAGOD_FRIEND_CENSE.getdataildata(self, value)
	return self.dataildata
end
