
require "common/RequestMessage"

-- [1024]请求随机名字 -- 角色 

REQ_ROLE_RAND_NAME = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_RAND_NAME
	self:init(1 ,{ 1025,700 })
end)

function REQ_ROLE_RAND_NAME.serialize(self, writer)
	writer:writeInt8Unsigned(self.sex)  -- {性别(1:女[默认],2:男)}
end

function REQ_ROLE_RAND_NAME.setArguments(self,sex)
	self.sex = sex  -- {性别(1:女[默认],2:男)}
end

-- {性别(1:女[默认],2:男)}
function REQ_ROLE_RAND_NAME.setSex(self, sex)
	self.sex = sex
end
function REQ_ROLE_RAND_NAME.getSex(self)
	return self.sex
end
