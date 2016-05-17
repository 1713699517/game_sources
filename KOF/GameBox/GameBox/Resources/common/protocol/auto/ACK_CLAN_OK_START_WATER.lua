
require "common/AcknowledgementMessage"

-- (手动) -- [33345]浇水|摇钱成功 -- 社团 

ACK_CLAN_OK_START_WATER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_START_WATER
	self:init()
end)

function ACK_CLAN_OK_START_WATER.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {类型 1 浇水++ 【33335】| 2摇钱}
end

-- {类型 1 浇水++ 【33335】| 2摇钱}
function ACK_CLAN_OK_START_WATER.getType(self)
	return self.type
end
