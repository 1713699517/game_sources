
require "common/AcknowledgementMessage"

-- (手动) -- [32025]上香好友返回信息块 -- 财神 

ACK_WEAGOD_FRIEND_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_FRIEND_MSG_GROUP
	self:init()
end)

function ACK_WEAGOD_FRIEND_MSG_GROUP.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {好友Uid}
	self.name = reader:readString() -- {好友名字}
	self.country = reader:readInt8Unsigned() -- {好友阵营}
	self.lv = reader:readInt8Unsigned() -- {好友等级}
	self.state = reader:readInt8Unsigned() -- {上香状态(1：可上香|0：不可上香)}
	self.name_color = reader:readInt8Unsigned() -- {名字颜色}
end

-- {好友Uid}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getUid(self)
	return self.uid
end

-- {好友名字}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getName(self)
	return self.name
end

-- {好友阵营}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getCountry(self)
	return self.country
end

-- {好友等级}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getLv(self)
	return self.lv
end

-- {上香状态(1：可上香|0：不可上香)}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getState(self)
	return self.state
end

-- {名字颜色}
function ACK_WEAGOD_FRIEND_MSG_GROUP.getNameColor(self)
	return self.name_color
end
