
require "common/AcknowledgementMessage"

-- [21137]怪物数据刷新 -- 活动-保卫经书 

ACK_DEFEND_BOOK_MONSTER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_MONSTER_DATA
	self:init()
end)

function ACK_DEFEND_BOOK_MONSTER_DATA.deserialize(self, reader)
	self.gmid = reader:readInt32Unsigned() -- {怪物组生成ID}
	self.mhp = reader:readInt32Unsigned() -- {怪物当前血量}
	self.allmhp = reader:readInt32Unsigned() -- {怪物总血量}
end

-- {怪物组生成ID}
function ACK_DEFEND_BOOK_MONSTER_DATA.getGmid(self)
	return self.gmid
end

-- {怪物当前血量}
function ACK_DEFEND_BOOK_MONSTER_DATA.getMhp(self)
	return self.mhp
end

-- {怪物总血量}
function ACK_DEFEND_BOOK_MONSTER_DATA.getAllmhp(self)
	return self.allmhp
end
