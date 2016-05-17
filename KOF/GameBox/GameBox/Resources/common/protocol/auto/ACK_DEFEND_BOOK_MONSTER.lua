
require "common/AcknowledgementMessage"

-- [21136]怪物数据组 -- 活动-保卫经书 

ACK_DEFEND_BOOK_MONSTER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_MONSTER
	self:init()
end)

function ACK_DEFEND_BOOK_MONSTER.deserialize(self, reader)
	self.gmid = reader:readInt32Unsigned() -- {怪物编号ID}
	self.mid = reader:readInt16Unsigned() -- {怪物id}
	self.pos_x = reader:readInt8Unsigned() -- {X轴格位}
	self.pos_y = reader:readInt8Unsigned() -- {Y轴格位}
	self.mhp = reader:readInt32Unsigned() -- {怪物当前血量}
	self.allmhp = reader:readInt32Unsigned() -- {怪物总血量}
end

-- {怪物编号ID}
function ACK_DEFEND_BOOK_MONSTER.getGmid(self)
	return self.gmid
end

-- {怪物id}
function ACK_DEFEND_BOOK_MONSTER.getMid(self)
	return self.mid
end

-- {X轴格位}
function ACK_DEFEND_BOOK_MONSTER.getPosX(self)
	return self.pos_x
end

-- {Y轴格位}
function ACK_DEFEND_BOOK_MONSTER.getPosY(self)
	return self.pos_y
end

-- {怪物当前血量}
function ACK_DEFEND_BOOK_MONSTER.getMhp(self)
	return self.mhp
end

-- {怪物总血量}
function ACK_DEFEND_BOOK_MONSTER.getAllmhp(self)
	return self.allmhp
end
