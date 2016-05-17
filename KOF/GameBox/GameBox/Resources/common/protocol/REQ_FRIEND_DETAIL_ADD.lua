
require "common/RequestMessage"

-- [4008]请求添加关系人详情 -- 好友 


REQ_FRIEND_DETAIL_ADD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_DETAIL_ADD
	self:init()
end)

function REQ_FRIEND_DETAIL_ADD.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)
	writer:writeInt16Unsigned(self.fsid)
	writer:writeInt32Unsigned(self.fuid)
end

function REQ_FRIEND_DETAIL_ADD.setArguments(self,type,fsid,fuid)
	self.type = type
	self.fsid = fsid
	self.fuid = fuid
end

function REQ_FRIEND_DETAIL_ADD.gettype(self, value)
	return self.type
end

function REQ_FRIEND_DETAIL_ADD.getfsid(self, value)
	return self.fsid
end

function REQ_FRIEND_DETAIL_ADD.getfuid(self, value)
	return self.fuid
end
