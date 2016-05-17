
require "common/AcknowledgementMessage"

-- [33027]社团仓库数据返回 -- 社团 

ACK_CLAN_DEPOT_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_DEPOT_BACK
	self:init()
end)

-- {物品数量}
function ACK_CLAN_DEPOT_BACK.getCount(self)
	return self.count
end

-- {物品数据块2001}
function ACK_CLAN_DEPOT_BACK.getMsgXxx(self)
	return self.msg_xxx
end
