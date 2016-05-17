
require "common/AcknowledgementMessage"

-- [45620]界面请求返回 -- 活动-阵营战 

ACK_CAMPWAR_OK_ASK_WAR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_OK_ASK_WAR
	self:init()
end)

function ACK_CAMPWAR_OK_ASK_WAR.deserialize(self, reader)
	self.time = reader:readInt16Unsigned() -- {活动时长（s）}
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.camp = reader:readInt8Unsigned() -- {玩家阵营}
end

-- {活动时长（s）}
function ACK_CAMPWAR_OK_ASK_WAR.getTime(self)
	return self.time
end

-- {玩家Uid}
function ACK_CAMPWAR_OK_ASK_WAR.getUid(self)
	return self.uid
end

-- {玩家阵营}
function ACK_CAMPWAR_OK_ASK_WAR.getCamp(self)
	return self.camp
end
