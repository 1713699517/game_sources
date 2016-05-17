
require "common/AcknowledgementMessage"

-- [33024]成员信息返回 -- 社团 

ACK_CLAN_MEM_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_MEM_BACK
	self:init()
end)

-- {成员数量}
function ACK_CLAN_MEM_BACK.getCount(self)
	return self.count
end

-- {成员信息块33008}
function ACK_CLAN_MEM_BACK.getMsgXxx(self)
	return self.msg_xxx
end
