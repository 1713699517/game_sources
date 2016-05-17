
require "common/AcknowledgementMessage"

-- [33001]通知  【废除不用】 -- 社团 

ACK_CLAN_MESSAGE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_MESSAGE
	self:init()
end)

function ACK_CLAN_MESSAGE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {通知类型 CONST_CLAN_MSG_TYPE_XXX}
	self.state = reader:readInt8Unsigned() -- {审核结果 1 true| 0 false}
	self.clan_name = reader:readString() -- {帮派名字}
	self.ok_name = reader:readString() -- {审核人名字}
end

-- {通知类型 CONST_CLAN_MSG_TYPE_XXX}
function ACK_CLAN_MESSAGE.getType(self)
	return self.type
end

-- {审核结果 1 true| 0 false}
function ACK_CLAN_MESSAGE.getState(self)
	return self.state
end

-- {帮派名字}
function ACK_CLAN_MESSAGE.getClanName(self)
	return self.clan_name
end

-- {审核人名字}
function ACK_CLAN_MESSAGE.getOkName(self)
	return self.ok_name
end
