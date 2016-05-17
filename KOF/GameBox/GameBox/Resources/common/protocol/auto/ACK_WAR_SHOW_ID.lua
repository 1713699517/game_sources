
require "common/AcknowledgementMessage"

-- (手动) -- [6120]战斗数据展示ID -- 战斗 

ACK_WAR_SHOW_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_SHOW_ID
	self:init()
end)

function ACK_WAR_SHOW_ID.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {战斗数据展示ID}
	self.luid = reader:readInt32Unsigned() -- {发起战斗人uid}
	self.lsid = reader:readInt16Unsigned() -- {发起战斗人uid}
	self.luname = reader:readUTF() -- {发起人名字}
	self.ruid = reader:readInt32Unsigned() -- {被打玩家uid}
	self.rsid = reader:readInt16Unsigned() -- {被打玩家sid}
	self.runame = reader:readUTF() -- {被打人名字}
end

-- {战斗数据展示ID}
function ACK_WAR_SHOW_ID.getId(self)
	return self.id
end

-- {发起战斗人uid}
function ACK_WAR_SHOW_ID.getLuid(self)
	return self.luid
end

-- {发起战斗人uid}
function ACK_WAR_SHOW_ID.getLsid(self)
	return self.lsid
end

-- {发起人名字}
function ACK_WAR_SHOW_ID.getLuname(self)
	return self.luname
end

-- {被打玩家uid}
function ACK_WAR_SHOW_ID.getRuid(self)
	return self.ruid
end

-- {被打玩家sid}
function ACK_WAR_SHOW_ID.getRsid(self)
	return self.rsid
end

-- {被打人名字}
function ACK_WAR_SHOW_ID.getRuname(self)
	return self.runame
end
