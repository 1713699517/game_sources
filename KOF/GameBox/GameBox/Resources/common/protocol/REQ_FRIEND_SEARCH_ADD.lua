
require "common/RequestMessage"

-- [4050]查找好友 -- 好友 

REQ_FRIEND_SEARCH_ADD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_SEARCH_ADD
	self:init()
end)

function REQ_FRIEND_SEARCH_ADD.serialize(self, writer)
	writer:writeString(self.funame)  -- {好友的昵称}
end

function REQ_FRIEND_SEARCH_ADD.setArguments(self,funame)
	self.funame = funame  -- {好友的昵称}
end

-- {好友的昵称}
function REQ_FRIEND_SEARCH_ADD.setFuname(self, funame)
	self.funame = funame
end
function REQ_FRIEND_SEARCH_ADD.getFuname(self)
	return self.funame
end
