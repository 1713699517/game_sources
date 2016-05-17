
require "common/AcknowledgementMessage"

-- [39585]通关信息块 -- 英雄副本 

ACK_HERO_OVER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_OVER_DATA
	self:init()
end)

function ACK_HERO_OVER_DATA.deserialize(self, reader)
	self.uname = reader:readString() -- {玩家姓名}
	self.count = reader:readInt16Unsigned() -- {}
	self.msg_good = reader:readXXXGroup() -- {物品信息块}
end

-- {玩家姓名}
function ACK_HERO_OVER_DATA.getUname(self)
	return self.uname
end

-- {}
function ACK_HERO_OVER_DATA.getCount(self)
	return self.count
end

-- {物品信息块}
function ACK_HERO_OVER_DATA.getMsgGood(self)
	return self.msg_good
end
