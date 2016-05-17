
require "common/AcknowledgementMessage"

-- [24830]排行信息块 -- 排行榜 

ACK_TOP_XXXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_XXXX
	self:init()
end)

function ACK_TOP_XXXX.deserialize(self, reader)
	self.rank = reader:readInt16Unsigned() -- {排名}
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.name = reader:readString() -- {玩家名字}
	self.name_color = reader:readInt8Unsigned() -- {名字颜色}
	self.clan_id = reader:readInt16Unsigned() -- {家族ID}
	self.clan_name = reader:readString() -- {家族名字}
	self.lv = reader:readInt16Unsigned() -- {玩家等级}
	self.power = reader:readInt32Unsigned() -- {玩家战斗力}
end

-- {排名}
function ACK_TOP_XXXX.getRank(self)
	return self.rank
end

-- {玩家UID}
function ACK_TOP_XXXX.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_TOP_XXXX.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_TOP_XXXX.getNameColor(self)
	return self.name_color
end

-- {家族ID}
function ACK_TOP_XXXX.getClanId(self)
	return self.clan_id
end

-- {家族名字}
function ACK_TOP_XXXX.getClanName(self)
	return self.clan_name
end

-- {玩家等级}
function ACK_TOP_XXXX.getLv(self)
	return self.lv
end

-- {玩家战斗力}
function ACK_TOP_XXXX.getPower(self)
	return self.power
end
