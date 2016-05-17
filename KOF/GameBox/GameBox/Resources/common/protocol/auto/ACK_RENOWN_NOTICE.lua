
require "common/AcknowledgementMessage"

-- [22106]提醒领取俸禄 -- 声望 

ACK_RENOWN_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_RENOWN_NOTICE
	self:init()
end)

function ACK_RENOWN_NOTICE.deserialize(self, reader)
	self.renown_lv = reader:readInt8Unsigned() -- {当前声望等级}
end

-- {当前声望等级}
function ACK_RENOWN_NOTICE.getRenownLv(self)
	return self.renown_lv
end
