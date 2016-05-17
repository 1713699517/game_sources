
require "common/AcknowledgementMessage"

-- (手动) -- [4080]添加联系人成功 -- 好友 

ACK_FRIEND_ADD_SUCCESS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_ADD_SUCCESS
	self:init()
end)

function ACK_FRIEND_ADD_SUCCESS.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {好友id}
	self.funame = reader:readString() -- {好友昵称}
	self.type = reader:readInt8Unsigned() -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
end

-- {好友id}
function ACK_FRIEND_ADD_SUCCESS.getFid(self)
	return self.fid
end

-- {好友昵称}
function ACK_FRIEND_ADD_SUCCESS.getFuname(self)
	return self.funame
end

-- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
function ACK_FRIEND_ADD_SUCCESS.getType(self)
	return self.type
end
