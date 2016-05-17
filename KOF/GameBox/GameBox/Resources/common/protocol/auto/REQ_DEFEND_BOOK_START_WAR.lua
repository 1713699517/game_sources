
require "common/RequestMessage"

-- [21210]开始战斗 -- 活动-保卫经书 

REQ_DEFEND_BOOK_START_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_START_WAR
	self:init(0, nil)
end)

function REQ_DEFEND_BOOK_START_WAR.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {战斗|采集|训服(类型见常量)}
	writer:writeInt32Unsigned(self.monster_gmid)  -- {怪物组生成ID}
	writer:writeInt16Unsigned(self.monster_gid)  -- {怪物组Id}
end

function REQ_DEFEND_BOOK_START_WAR.setArguments(self,type,monster_gmid,monster_gid)
	self.type = type  -- {战斗|采集|训服(类型见常量)}
	self.monster_gmid = monster_gmid  -- {怪物组生成ID}
	self.monster_gid = monster_gid  -- {怪物组Id}
end

-- {战斗|采集|训服(类型见常量)}
function REQ_DEFEND_BOOK_START_WAR.setType(self, type)
	self.type = type
end
function REQ_DEFEND_BOOK_START_WAR.getType(self)
	return self.type
end

-- {怪物组生成ID}
function REQ_DEFEND_BOOK_START_WAR.setMonsterGmid(self, monster_gmid)
	self.monster_gmid = monster_gmid
end
function REQ_DEFEND_BOOK_START_WAR.getMonsterGmid(self)
	return self.monster_gmid
end

-- {怪物组Id}
function REQ_DEFEND_BOOK_START_WAR.setMonsterGid(self, monster_gid)
	self.monster_gid = monster_gid
end
function REQ_DEFEND_BOOK_START_WAR.getMonsterGid(self)
	return self.monster_gid
end
