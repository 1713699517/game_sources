
require "common/AcknowledgementMessage"

-- (手动) -- [4210]系统推荐好友信息块 -- 好友 

ACK_FRIEND_SYS_FRIEND_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_SYS_FRIEND_GROUP
	self:init()
end)

function ACK_FRIEND_SYS_FRIEND_GROUP.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {玩家id}
	self.name = reader:readString() -- {玩家昵称}
	self.lv = reader:readInt8Unsigned() -- {玩家等级}
	self.clan = reader:readString() -- {玩家社团}
end

-- {玩家id}
function ACK_FRIEND_SYS_FRIEND_GROUP.getFid(self)
	return self.fid
end

-- {玩家昵称}
function ACK_FRIEND_SYS_FRIEND_GROUP.getName(self)
	return self.name
end

-- {玩家等级}
function ACK_FRIEND_SYS_FRIEND_GROUP.getLv(self)
	return self.lv
end

-- {玩家社团}
function ACK_FRIEND_SYS_FRIEND_GROUP.getClan(self)
	return self.clan
end
