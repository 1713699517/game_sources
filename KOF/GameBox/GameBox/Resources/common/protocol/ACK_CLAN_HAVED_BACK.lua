
require "common/AcknowledgementMessage"

-- [33102]已申请过的社团 -- 社团 

ACK_CLAN_HAVED_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_HAVED_BACK
	self:init()
end)

-- {数量}
function ACK_CLAN_HAVED_BACK.getCount(self)
	return self.count
end

-- {社团id}
function ACK_CLAN_HAVED_BACK.getId(self)
	return self.id
end
