
require "common/RequestMessage"

-- [1333]玩家点击签到 -- 角色 

REQ_ROLE_CLICK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_CLICK
	self:init(0, nil)
end)

function REQ_ROLE_CLICK.serialize(self, writer)
	writer:writeInt8Unsigned(self.cltype)  -- {签到类型-见常量[CONST_SIGN_玩家类型]}
end

function REQ_ROLE_CLICK.setArguments(self,cltype)
	self.cltype = cltype  -- {签到类型-见常量[CONST_SIGN_玩家类型]}
end

-- {签到类型-见常量[CONST_SIGN_玩家类型]}
function REQ_ROLE_CLICK.setCltype(self, cltype)
	self.cltype = cltype
end
function REQ_ROLE_CLICK.getCltype(self)
	return self.cltype
end
