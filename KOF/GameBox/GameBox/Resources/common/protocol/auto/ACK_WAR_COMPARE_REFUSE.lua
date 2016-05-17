
require "common/AcknowledgementMessage"

-- (手动) -- [6090]请求切磋-被拒绝 -- 战斗 

ACK_WAR_COMPARE_REFUSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_COMPARE_REFUSE
	self:init()
end)

function ACK_WAR_COMPARE_REFUSE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {被请求玩家Uid}
	self.lv = reader:readInt8Unsigned() -- {被请求玩家等级}
	self.name = reader:readString() -- {被请求玩家名称}
end

-- {被请求玩家Uid}
function ACK_WAR_COMPARE_REFUSE.getUid(self)
	return self.uid
end

-- {被请求玩家等级}
function ACK_WAR_COMPARE_REFUSE.getLv(self)
	return self.lv
end

-- {被请求玩家名称}
function ACK_WAR_COMPARE_REFUSE.getName(self)
	return self.name
end
