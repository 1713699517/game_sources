
require "common/RequestMessage"

-- [1020]创建角色 -- 角色 

REQ_ROLE_CREATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_CREATE
	self:init(1 ,{ 1021,700 })
end)

function REQ_ROLE_CREATE.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {用户ID}
	writer:writeInt32Unsigned(self.uuid)  -- {账号}
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt16Unsigned(self.cid)  -- {联运商cid}
	writer:writeString(self.os)  -- {系统类型 android,ios,wp,win,mac}
	writer:writeInt32Unsigned(self.versions)  -- {游戏程序版本(*10000取整)}
	writer:writeString(self.uname)  -- {角色名}
	writer:writeInt8Unsigned(self.sex)  -- {性别}
	writer:writeInt8Unsigned(self.pro)  -- {职业}
	writer:writeString(self.source)  -- {来源渠道}
	writer:writeString(self.source_sub)  -- {子渠道}
	writer:writeInt32Unsigned(self.login_time)  -- {时间}
	writer:writeInt16Unsigned(self.ext1)  -- {保留1}
	writer:writeInt16Unsigned(self.ext2)  -- {保留2}
end

function REQ_ROLE_CREATE.setArguments(self,uid,uuid,sid,cid,os,versions,uname,sex,pro,source,source_sub,login_time,ext1,ext2)
	self.uid = uid  -- {用户ID}
	self.uuid = uuid  -- {账号}
	self.sid = sid  -- {服务器ID}
	self.cid = cid  -- {联运商cid}
	self.os = os  -- {系统类型 android,ios,wp,win,mac}
	self.versions = versions  -- {游戏程序版本(*10000取整)}
	self.uname = uname  -- {角色名}
	self.sex = sex  -- {性别}
	self.pro = pro  -- {职业}
	self.source = source  -- {来源渠道}
	self.source_sub = source_sub  -- {子渠道}
	self.login_time = login_time  -- {时间}
	self.ext1 = ext1  -- {保留1}
	self.ext2 = ext2  -- {保留2}
end

-- {用户ID}
function REQ_ROLE_CREATE.setUid(self, uid)
	self.uid = uid
end
function REQ_ROLE_CREATE.getUid(self)
	return self.uid
end

-- {账号}
function REQ_ROLE_CREATE.setUuid(self, uuid)
	self.uuid = uuid
end
function REQ_ROLE_CREATE.getUuid(self)
	return self.uuid
end

-- {服务器ID}
function REQ_ROLE_CREATE.setSid(self, sid)
	self.sid = sid
end
function REQ_ROLE_CREATE.getSid(self)
	return self.sid
end

-- {联运商cid}
function REQ_ROLE_CREATE.setCid(self, cid)
	self.cid = cid
end
function REQ_ROLE_CREATE.getCid(self)
	return self.cid
end

-- {系统类型 android,ios,wp,win,mac}
function REQ_ROLE_CREATE.setOs(self, os)
	self.os = os
end
function REQ_ROLE_CREATE.getOs(self)
	return self.os
end

-- {游戏程序版本(*10000取整)}
function REQ_ROLE_CREATE.setVersions(self, versions)
	self.versions = versions
end
function REQ_ROLE_CREATE.getVersions(self)
	return self.versions
end

-- {角色名}
function REQ_ROLE_CREATE.setUname(self, uname)
	self.uname = uname
end
function REQ_ROLE_CREATE.getUname(self)
	return self.uname
end

-- {性别}
function REQ_ROLE_CREATE.setSex(self, sex)
	self.sex = sex
end
function REQ_ROLE_CREATE.getSex(self)
	return self.sex
end

-- {职业}
function REQ_ROLE_CREATE.setPro(self, pro)
	self.pro = pro
end
function REQ_ROLE_CREATE.getPro(self)
	return self.pro
end

-- {来源渠道}
function REQ_ROLE_CREATE.setSource(self, source)
	self.source = source
end
function REQ_ROLE_CREATE.getSource(self)
	return self.source
end

-- {子渠道}
function REQ_ROLE_CREATE.setSourceSub(self, source_sub)
	self.source_sub = source_sub
end
function REQ_ROLE_CREATE.getSourceSub(self)
	return self.source_sub
end

-- {时间}
function REQ_ROLE_CREATE.setLoginTime(self, login_time)
	self.login_time = login_time
end
function REQ_ROLE_CREATE.getLoginTime(self)
	return self.login_time
end

-- {保留1}
function REQ_ROLE_CREATE.setExt1(self, ext1)
	self.ext1 = ext1
end
function REQ_ROLE_CREATE.getExt1(self)
	return self.ext1
end

-- {保留2}
function REQ_ROLE_CREATE.setExt2(self, ext2)
	self.ext2 = ext2
end
function REQ_ROLE_CREATE.getExt2(self)
	return self.ext2
end
