
require "common/AcknowledgementMessage"

-- [4090]发送添加好友通知 -- 好友 

ACK_FRIEND_ADD_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_ADD_NOTICE
	self:init()
end)

function ACK_FRIEND_ADD_NOTICE.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {好友id}
	self.fname = reader:readString() -- {好友名字}
end

-- {好友id}
function ACK_FRIEND_ADD_NOTICE.getFid(self)
	return self.fid
end

-- {好友名字}
function ACK_FRIEND_ADD_NOTICE.getFname(self)
	return self.fname
end
