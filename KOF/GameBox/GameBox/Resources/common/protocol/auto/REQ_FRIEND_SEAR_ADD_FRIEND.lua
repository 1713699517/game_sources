
require "common/RequestMessage"

-- (手动) -- [4035]查找添加好友 -- 好友 

REQ_FRIEND_SEAR_ADD_FRIEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_SEAR_ADD_FRIEND
	self:init()
end)

function REQ_FRIEND_SEAR_ADD_FRIEND.serialize(self, writer)
	writer:writeString(self.uname)  -- {玩家名称}
end

function REQ_FRIEND_SEAR_ADD_FRIEND.setArguments(self,uname)
	self.uname = uname  -- {玩家名称}
end

-- {玩家名称}
function REQ_FRIEND_SEAR_ADD_FRIEND.setUname(self, uname)
	self.uname = uname
end
function REQ_FRIEND_SEAR_ADD_FRIEND.getUname(self)
	return self.uname
end
