
require "common/AcknowledgementMessage"

-- [6060]接收PK邀请 -- 战斗 

ACK_WAR_PK_RECEIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_PK_RECEIVE
	self:init()
end)

function ACK_WAR_PK_RECEIVE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {邀请人UID}
	self.name = reader:readString() -- {邀请人名字}
	self.time = reader:readInt32Unsigned() -- {时间}
end

-- {邀请人UID}
function ACK_WAR_PK_RECEIVE.getUid(self)
	return self.uid
end

-- {邀请人名字}
function ACK_WAR_PK_RECEIVE.getName(self)
	return self.name
end

-- {时间}
function ACK_WAR_PK_RECEIVE.getTime(self)
	return self.time
end
