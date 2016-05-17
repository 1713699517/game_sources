
require "common/AcknowledgementMessage"

-- [33020]社团列表数据返回 -- 社团 

ACK_CLAN_LIST_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_LIST_BACK
	self:init()
end)

-- {当前页数}
function ACK_CLAN_LIST_BACK.getPage(self)
	return self.page
end

-- {总页数}
function ACK_CLAN_LIST_BACK.getSum(self)
	return self.sum
end

-- {数量}
function ACK_CLAN_LIST_BACK.getCout(self)
	return self.cout
end

-- {信息块33002}
function ACK_CLAN_LIST_BACK.getMsgXxx(self)
	return self.msg_xxx
end
