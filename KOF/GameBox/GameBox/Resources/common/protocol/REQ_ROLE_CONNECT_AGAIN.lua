
require "common/RequestMessage"

-- (手动) -- [1010]断线重连 -- 角色 

REQ_ROLE_CONNECT_AGAIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_CONNECT_AGAIN
	self:init()
end)

function REQ_ROLE_CONNECT_AGAIN.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {用户ID	}
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.login_time)  -- {时间}
	writer:writeString(self.pwd)  -- {密码}
	writer:writeInt32Unsigned(self.fcm)  -- {防沉迷(0:已解除 n>0:已在线时长)}
	writer:writeInt8Unsigned(self.client)  -- {客户端类型(见:CONST_CLIENT_*)}
	writer:writeBoolean(self.debug)  -- {是否调试 （web:false fb:true）}
end

function REQ_ROLE_CONNECT_AGAIN.setArguments(self,uid,sid,login_time,pwd,fcm,client,debug)
	self.uid = uid  -- {用户ID	}
	self.sid = sid  -- {服务器ID}
	self.login_time = login_time  -- {时间}
	self.pwd = pwd  -- {密码}
	self.fcm = fcm  -- {防沉迷(0:已解除 n>0:已在线时长)}
	self.client = client  -- {客户端类型(见:CONST_CLIENT_*)}
	self.debug = debug  -- {是否调试 （web:false fb:true）}
end

-- {用户ID	}
function REQ_ROLE_CONNECT_AGAIN.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_CONNECT_AGAIN.getUid(self)
	return self.uid
end

-- {服务器ID}
function REQ_ROLE_CONNECT_AGAIN.setSid(self, sid)
	self.sid = sid
end
function REQ_ROLE_CONNECT_AGAIN.getSid(self)
	return self.sid
end

-- {时间}
function REQ_ROLE_CONNECT_AGAIN.setLoginTime(self, login_time)
	self.login_time = login_time
end
function REQ_ROLE_CONNECT_AGAIN.getLoginTime(self)
	return self.login_time
end

-- {密码}
function REQ_ROLE_CONNECT_AGAIN.setPwd(self, pwd)
	self.pwd = pwd
end
function REQ_ROLE_CONNECT_AGAIN.getPwd(self)
	return self.pwd
end

-- {防沉迷(0:已解除 n>0:已在线时长)}
function REQ_ROLE_CONNECT_AGAIN.setFcm(self, fcm)
	self.fcm = fcm
end
function REQ_ROLE_CONNECT_AGAIN.getFcm(self)
	return self.fcm
end

-- {客户端类型(见:CONST_CLIENT_*)}
function REQ_ROLE_CONNECT_AGAIN.setClient(self, client)
	self.client = client
end
function REQ_ROLE_CONNECT_AGAIN.getClient(self)
	return self.client
end

-- {是否调试 （web:false fb:true）}
function REQ_ROLE_CONNECT_AGAIN.setDebug(self, debug)
	self.debug = debug
end
function REQ_ROLE_CONNECT_AGAIN.getDebug(self)
	return self.debug
end
