
require "common/AcknowledgementMessage"

-- [1332]请求签到面板成功 -- 角色 

ACK_ROLE_OK_REQUEST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OK_REQUEST
	self:init()
end)

function ACK_ROLE_OK_REQUEST.deserialize(self, reader)
	self.viplv = reader:readInt8Unsigned() -- {当前vip等级}
	self.num = reader:readInt8Unsigned() -- {第几天签到}
	self.signvip = reader:readInt8Unsigned() -- {Vip签到标记[见常量CONST_SIGN_*]}
	self.signcom = reader:readInt8Unsigned() -- {普通签到标记[见常量CONST_SIGN_*]}
end

-- {当前vip等级}
function ACK_ROLE_OK_REQUEST.getViplv(self)
	return self.viplv
end

-- {第几天签到}
function ACK_ROLE_OK_REQUEST.getNum(self)
	return self.num
end

-- {Vip签到标记[见常量CONST_SIGN_*]}
function ACK_ROLE_OK_REQUEST.getSignvip(self)
	return self.signvip
end

-- {普通签到标记[见常量CONST_SIGN_*]}
function ACK_ROLE_OK_REQUEST.getSigncom(self)
	return self.signcom
end
