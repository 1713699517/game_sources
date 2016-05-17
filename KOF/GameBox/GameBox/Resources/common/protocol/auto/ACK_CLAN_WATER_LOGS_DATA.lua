
require "common/AcknowledgementMessage"

-- [33335]浇水日志数据块 -- 社团 

ACK_CLAN_WATER_LOGS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_WATER_LOGS_DATA
	self:init()
end)

function ACK_CLAN_WATER_LOGS_DATA.deserialize(self, reader)
	self.name = reader:readString() -- {玩家名字}
	self.name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.type = reader:readInt8Unsigned() -- {日志类型:[1清水|2甘泉|3清风露]}
end

-- {玩家名字}
function ACK_CLAN_WATER_LOGS_DATA.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_CLAN_WATER_LOGS_DATA.getNameColor(self)
	return self.name_color
end

-- {日志类型:[1清水|2甘泉|3清风露]}
function ACK_CLAN_WATER_LOGS_DATA.getType(self)
	return self.type
end
