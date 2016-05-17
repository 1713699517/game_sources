
require "common/AcknowledgementMessage"

-- (手动) -- [4100]最近联系人 -- 好友 

ACK_FRIEND_RECENT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_RECENT
	self:init()
end)

function ACK_FRIEND_RECENT.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {好友id}
	self.fname = reader:readString() -- {好友昵称}
	self.flv = reader:readInt8Unsigned() -- {好友等级}
	self.page = reader:readInt16Unsigned() -- {显示页数}
end

-- {好友id}
function ACK_FRIEND_RECENT.getFid(self)
	return self.fid
end

-- {好友昵称}
function ACK_FRIEND_RECENT.getFname(self)
	return self.fname
end

-- {好友等级}
function ACK_FRIEND_RECENT.getFlv(self)
	return self.flv
end

-- {显示页数}
function ACK_FRIEND_RECENT.getPage(self)
	return self.page
end
