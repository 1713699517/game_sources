
require "common/RequestMessage"

-- [4075]添加好友详情 -- 好友 

REQ_FRIEND_ADD_DETAIL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_ADD_DETAIL
	self:init()
end)

function REQ_FRIEND_ADD_DETAIL.serialize(self, writer)
	writer:writeInt32Unsigned(self.fuid)  -- {好友id}
end

function REQ_FRIEND_ADD_DETAIL.setArguments(self,fuid)
	self.fuid = fuid  -- {好友id}
end

-- {好友id}
function REQ_FRIEND_ADD_DETAIL.setFuid(self, fuid)
	self.fuid = fuid
end
function REQ_FRIEND_ADD_DETAIL.getFuid(self)
	return self.fuid
end
