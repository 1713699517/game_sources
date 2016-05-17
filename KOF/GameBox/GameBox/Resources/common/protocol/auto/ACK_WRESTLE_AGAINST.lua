
require "common/AcknowledgementMessage"

-- [54870]决赛对阵信息返回 -- 格斗之王 

ACK_WRESTLE_AGAINST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_AGAINST
	self:init()
end)

function ACK_WRESTLE_AGAINST.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {0:上半区|1:下半区}
	self.lunci = reader:readInt8Unsigned() -- {轮次}
	self.uid1 = reader:readInt32Unsigned() -- {一号玩家}
	self.name1 = reader:readString() -- {一号玩家名字}
	self.uid2 = reader:readInt32Unsigned() -- {二号玩家|0:轮空}
	self.name2 = reader:readString() -- {二号玩家名字}
	self.uid = reader:readInt32Unsigned() -- {胜利玩家|0:还未决出胜利}
end

-- {0:上半区|1:下半区}
function ACK_WRESTLE_AGAINST.getType(self)
	return self.type
end

-- {轮次}
function ACK_WRESTLE_AGAINST.getLunci(self)
	return self.lunci
end

-- {一号玩家}
function ACK_WRESTLE_AGAINST.getUid1(self)
	return self.uid1
end

-- {一号玩家名字}
function ACK_WRESTLE_AGAINST.getName1(self)
	return self.name1
end

-- {二号玩家|0:轮空}
function ACK_WRESTLE_AGAINST.getUid2(self)
	return self.uid2
end

-- {二号玩家名字}
function ACK_WRESTLE_AGAINST.getName2(self)
	return self.name2
end

-- {胜利玩家|0:还未决出胜利}
function ACK_WRESTLE_AGAINST.getUid(self)
	return self.uid
end
