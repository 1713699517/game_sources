
require "common/AcknowledgementMessage"

-- [4025]返回好友列表信息块 -- 好友 

ACK_FRIEND_INFO_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_INFO_GROUP
	self:init()
end)

function ACK_FRIEND_INFO_GROUP.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {好友uid}
	self.fname = reader:readString() -- {好友昵称}
	self.fclan = reader:readInt8Unsigned() -- {好友社团}
	self.flv = reader:readInt8Unsigned() -- {好友等级}
	self.isonline = reader:readInt16Unsigned() -- {是否在线}
	self.pro = reader:readInt8Unsigned() -- {职业}
end

-- {好友uid}
function ACK_FRIEND_INFO_GROUP.getFid(self)
	return self.fid
end

-- {好友昵称}
function ACK_FRIEND_INFO_GROUP.getFname(self)
	return self.fname
end

-- {好友社团}
function ACK_FRIEND_INFO_GROUP.getFclan(self)
	return self.fclan
end

-- {好友等级}
function ACK_FRIEND_INFO_GROUP.getFlv(self)
	return self.flv
end

-- {是否在线}
function ACK_FRIEND_INFO_GROUP.getIsonline(self)
	return self.isonline
end

-- {职业}
function ACK_FRIEND_INFO_GROUP.getPro(self)
	return self.pro
end
