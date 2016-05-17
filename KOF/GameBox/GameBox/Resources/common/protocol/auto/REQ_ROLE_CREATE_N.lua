
require "common/RequestMessage"

-- [1241]腾讯创建角色 -- 角色 

REQ_ROLE_CREATE_N = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_CREATE_N
	self:init(0, nil)
end)

function REQ_ROLE_CREATE_N.serialize(self, writer)
	writer:writeString(self.name)  -- {玩家名称}
	writer:writeInt8Unsigned(self.sex)  -- {性别}
	writer:writeInt8Unsigned(self.career)  -- {职业}
end

function REQ_ROLE_CREATE_N.setArguments(self,name,sex,career)
	self.name = name  -- {玩家名称}
	self.sex = sex  -- {性别}
	self.career = career  -- {职业}
end

-- {玩家名称}
function REQ_ROLE_CREATE_N.setName(self, name)
	self.name = name
end
function REQ_ROLE_CREATE_N.getName(self)
	return self.name
end

-- {性别}
function REQ_ROLE_CREATE_N.setSex(self, sex)
	self.sex = sex
end
function REQ_ROLE_CREATE_N.getSex(self)
	return self.sex
end

-- {职业}
function REQ_ROLE_CREATE_N.setCareer(self, career)
	self.career = career
end
function REQ_ROLE_CREATE_N.getCareer(self)
	return self.career
end
