
require "common/AcknowledgementMessage"

-- [33338]社团战战报列表返回 -- 社团 

ACK_CLAN_WAR_RECS_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_WAR_RECS_BACK
	self:init()
end)

-- {战报记录数量}
function ACK_CLAN_WAR_RECS_BACK.getCount(self)
	return self.count
end

-- {社团战报数据块33339}
function ACK_CLAN_WAR_RECS_BACK.getMsgGroup(self)
	return self.msg_group
end
