
require "common/AcknowledgementMessage"

-- [33027]string数据块 -- 社团 

ACK_CLAN_STRING_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_STRING_MSG
	self:init()
end)

function ACK_CLAN_STRING_MSG.deserialize(self, reader)
	self.name = reader:readString() -- {名字}
	self.name_color = reader:readInt8Unsigned() -- {名字颜色}
end

-- {名字}
function ACK_CLAN_STRING_MSG.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_CLAN_STRING_MSG.getNameColor(self)
	return self.name_color
end
