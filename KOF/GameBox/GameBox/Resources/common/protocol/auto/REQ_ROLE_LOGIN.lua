
require "common/RequestMessage"

-- [1010]角色登录 -- 角色 

REQ_ROLE_LOGIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_LOGIN
	self:init(1 ,{ 1023,1021,700 })
end)

function REQ_ROLE_LOGIN.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {用户ID}
	writer:writeInt32Unsigned(self.uuid)  -- {帐号UUID}
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt16Unsigned(self.cid)  -- {平台cid}
	writer:writeString(self.os)  -- {系统类型 android,ios,wp,win,mac}
	writer:writeString(self.pwd)  -- {密码}
	writer:writeInt32Unsigned(self.versions)  -- {游戏程序版本(*10000取整)}
	writer:writeInt32Unsigned(self.fmc)  -- {防沉迷(0:已解除 n>0:已在线时长)}
	writer:writeBoolean(self.relink)  -- {是否重连（否：false 是：true）}
	writer:writeBoolean(self.debug)  -- {是否调试 （web:false fb:true）}
	writer:writeInt32Unsigned(self.login_time)  -- {时间}
end

function REQ_ROLE_LOGIN.setArguments(self,uid,uuid,sid,cid,os,pwd,versions,fmc,relink,debug,login_time)
	self.uid = uid  -- {用户ID}
	self.uuid = uuid  -- {帐号UUID}
	self.sid = sid  -- {服务器ID}
	self.cid = cid  -- {平台cid}
	self.os = os  -- {系统类型 android,ios,wp,win,mac}
	self.pwd = pwd  -- {密码}
	self.versions = versions  -- {游戏程序版本(*10000取整)}
	self.fmc = fmc  -- {防沉迷(0:已解除 n>0:已在线时长)}
	self.relink = relink  -- {是否重连（否：false 是：true）}
	self.debug = debug  -- {是否调试 （web:false fb:true）}
	self.login_time = login_time  -- {时间}
end

-- {用户ID}
function REQ_ROLE_LOGIN.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_LOGIN.getUid(self)
	return self.uid
end

-- {帐号UUID}
function REQ_ROLE_LOGIN.setUuid(self, uuid)
	self.uuid = uuid
end
function REQ_ROLE_LOGIN.getUuid(self)
	return self.uuid
end

-- {服务器ID}
function REQ_ROLE_LOGIN.setSid(self, sid)
	self.sid = sid
end
function REQ_ROLE_LOGIN.getSid(self)
	return self.sid
end

-- {平台cid}
function REQ_ROLE_LOGIN.setCid(self, cid)
	self.cid = cid
end
function REQ_ROLE_LOGIN.getCid(self)
	return self.cid
end

-- {系统类型 android,ios,wp,win,mac}
function REQ_ROLE_LOGIN.setOs(self, os)
	self.os = os
end
function REQ_ROLE_LOGIN.getOs(self)
	return self.os
end

-- {密码}
function REQ_ROLE_LOGIN.setPwd(self, pwd)
	self.pwd = pwd
end
function REQ_ROLE_LOGIN.getPwd(self)
	return self.pwd
end

-- {游戏程序版本(*10000取整)}
function REQ_ROLE_LOGIN.setVersions(self, versions)
	self.versions = versions
end
function REQ_ROLE_LOGIN.getVersions(self)
	return self.versions
end

-- {防沉迷(0:已解除 n>0:已在线时长)}
function REQ_ROLE_LOGIN.setFmc(self, fmc)
	self.fmc = fmc
end
function REQ_ROLE_LOGIN.getFmc(self)
	return self.fmc
end

-- {是否重连（否：false 是：true）}
function REQ_ROLE_LOGIN.setRelink(self, relink)
	self.relink = relink
end
function REQ_ROLE_LOGIN.getRelink(self)
	return self.relink
end

-- {是否调试 （web:false fb:true）}
function REQ_ROLE_LOGIN.setDebug(self, debug)
	self.debug = debug
end
function REQ_ROLE_LOGIN.getDebug(self)
	return self.debug
end

-- {时间}
function REQ_ROLE_LOGIN.setLoginTime(self, login_time)
	self.login_time = login_time
end
function REQ_ROLE_LOGIN.getLoginTime(self)
	return self.login_time
end
