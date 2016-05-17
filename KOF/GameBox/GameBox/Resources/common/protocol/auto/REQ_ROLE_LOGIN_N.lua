
require "common/RequestMessage"

-- [1240]腾讯玩家登陆 -- 角色 

REQ_ROLE_LOGIN_N = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_LOGIN_N
	self:init(0, nil)
end)

function REQ_ROLE_LOGIN_N.serialize(self, writer)
	writer:writeString(self.openid)  -- {腾讯OPENID}
	writer:writeString(self.openkey)  -- {腾讯OPENKEY}
end

function REQ_ROLE_LOGIN_N.setArguments(self,openid,openkey)
	self.openid = openid  -- {腾讯OPENID}
	self.openkey = openkey  -- {腾讯OPENKEY}
end

-- {腾讯OPENID}
function REQ_ROLE_LOGIN_N.setOpenid(self, openid)
	self.openid = openid
end
function REQ_ROLE_LOGIN_N.getOpenid(self)
	return self.openid
end

-- {腾讯OPENKEY}
function REQ_ROLE_LOGIN_N.setOpenkey(self, openkey)
	self.openkey = openkey
end
function REQ_ROLE_LOGIN_N.getOpenkey(self)
	return self.openkey
end
