
require "common/AcknowledgementMessage"

-- [1021]创建/登录(有角色)成功 -- 角色 

ACK_ROLE_LOGIN_OK_HAVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_LOGIN_OK_HAVE
	self:init()
end)

function ACK_ROLE_LOGIN_OK_HAVE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {用户ID}
	self.uname = reader:readString() -- {角色名}
	self.sex = reader:readInt8Unsigned() -- {性别}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.lv = reader:readInt16Unsigned() -- {等级}
	self.country = reader:readInt8Unsigned() -- {阵营}
	self.is_red_name = reader:readInt8Unsigned() -- {是否红名(CONST_PLAYER_FLAG_*)}
	self.skin_armor = reader:readInt16Unsigned() -- {衣服皮肤}
end

-- {用户ID}
function ACK_ROLE_LOGIN_OK_HAVE.getUid(self)
	return self.uid
end

-- {角色名}
function ACK_ROLE_LOGIN_OK_HAVE.getUname(self)
	return self.uname
end

-- {性别}
function ACK_ROLE_LOGIN_OK_HAVE.getSex(self)
	return self.sex
end

-- {职业}
function ACK_ROLE_LOGIN_OK_HAVE.getPro(self)
	return self.pro
end

-- {等级}
function ACK_ROLE_LOGIN_OK_HAVE.getLv(self)
	return self.lv
end

-- {阵营}
function ACK_ROLE_LOGIN_OK_HAVE.getCountry(self)
	return self.country
end

-- {是否红名(CONST_PLAYER_FLAG_*)}
function ACK_ROLE_LOGIN_OK_HAVE.getIsRedName(self)
	return self.is_red_name
end

-- {衣服皮肤}
function ACK_ROLE_LOGIN_OK_HAVE.getSkinArmor(self)
	return self.skin_armor
end
