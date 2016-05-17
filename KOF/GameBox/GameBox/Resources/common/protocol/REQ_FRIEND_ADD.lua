
require "common/RequestMessage"

-- [4013]请求添加关系人 -- 好友 


REQ_FRIEND_ADD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_ADD
	self:init()
end)

function REQ_FRIEND_ADD.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)
	writer:writeXXXGroup(self.adddetail)
end

function REQ_FRIEND_ADD.setArguments(self,count,adddetail)
	self.count = count
	self.adddetail = adddetail
end

function REQ_FRIEND_ADD.getcount(self, value)
	return self.count
end

function REQ_FRIEND_ADD.getadddetail(self, value)
	return self.adddetail
end
