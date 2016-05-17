
require "common/AcknowledgementMessage"

-- [1334]玩家签到成功 -- 角色 

ACK_ROLE_OK_CLICK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OK_CLICK
	self:init()
end)

function ACK_ROLE_OK_CLICK.deserialize(self, reader)
	self.cltype = reader:readInt8Unsigned() -- {签到类型-见常量[CONST_SIGN_玩家类型]}
end

-- {签到类型-见常量[CONST_SIGN_玩家类型]}
function ACK_ROLE_OK_CLICK.getCltype(self)
	return self.cltype
end
