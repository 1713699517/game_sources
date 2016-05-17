
require "common/AcknowledgementMessage"

-- [33380]返回地图数据 -- 社团 

ACK_CLAN_MAP_HEART = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_MAP_HEART
	self:init()
end)

-- {信息块(37020)}
function ACK_CLAN_MAP_HEART.getDataXxx(self)
	return self.data_xxx
end
