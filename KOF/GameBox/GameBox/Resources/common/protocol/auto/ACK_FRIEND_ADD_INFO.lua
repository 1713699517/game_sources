
require "common/AcknowledgementMessage"

-- (手动) -- [4060]返回查找好友信息 -- 好友 

ACK_FRIEND_ADD_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_ADD_INFO
	self:init()
end)

function ACK_FRIEND_ADD_INFO.deserialize(self, reader)
	self.fid = reader:readInt32() -- {好友id}
	self.fname = reader:readString() -- {好友昵称}
	self.fclan = reader:readString() -- {好友社团}
	self.flv = reader:readInt8Unsigned() -- {好友等级}
end

-- {好友id}
function ACK_FRIEND_ADD_INFO.getFid(self)
	return self.fid
end

-- {好友昵称}
function ACK_FRIEND_ADD_INFO.getFname(self)
	return self.fname
end

-- {好友社团}
function ACK_FRIEND_ADD_INFO.getFclan(self)
	return self.fclan
end

-- {好友等级}
function ACK_FRIEND_ADD_INFO.getFlv(self)
	return self.flv
end
