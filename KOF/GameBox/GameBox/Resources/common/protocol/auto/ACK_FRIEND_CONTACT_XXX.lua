
require "common/AcknowledgementMessage"

-- (手动) -- [4003]联系人协议块（4003） -- 好友 

ACK_FRIEND_CONTACT_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_CONTACT_XXX
	self:init()
end)

function ACK_FRIEND_CONTACT_XXX.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器Id}
	self.uid = reader:readInt32Unsigned() -- {用户ID}
	self.type = reader:readInt8Unsigned() -- {联系人类型}
	self.name = reader:readString() -- {昵称}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.sex = reader:readInt8Unsigned() -- {性别}
	self.lv = reader:readInt8Unsigned() -- {等级}
	self.country = reader:readInt8Unsigned() -- {阵营}
	self.clan = reader:readString() -- {社团}
	self.online = reader:readInt8Unsigned() -- {是否在线(1:在线,0:不在线)}
end

-- {服务器Id}
function ACK_FRIEND_CONTACT_XXX.getSid(self)
	return self.sid
end

-- {用户ID}
function ACK_FRIEND_CONTACT_XXX.getUid(self)
	return self.uid
end

-- {联系人类型}
function ACK_FRIEND_CONTACT_XXX.getType(self)
	return self.type
end

-- {昵称}
function ACK_FRIEND_CONTACT_XXX.getName(self)
	return self.name
end

-- {职业}
function ACK_FRIEND_CONTACT_XXX.getPro(self)
	return self.pro
end

-- {性别}
function ACK_FRIEND_CONTACT_XXX.getSex(self)
	return self.sex
end

-- {等级}
function ACK_FRIEND_CONTACT_XXX.getLv(self)
	return self.lv
end

-- {阵营}
function ACK_FRIEND_CONTACT_XXX.getCountry(self)
	return self.country
end

-- {社团}
function ACK_FRIEND_CONTACT_XXX.getClan(self)
	return self.clan
end

-- {是否在线(1:在线,0:不在线)}
function ACK_FRIEND_CONTACT_XXX.getOnline(self)
	return self.online
end
