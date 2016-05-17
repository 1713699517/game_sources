
require "common/AcknowledgementMessage"

-- (手动) -- [45760]玩家死亡 -- 活动-阵营战 

ACK_CAMPWAR_DIE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_DIE
	self:init()
end)

function ACK_CAMPWAR_DIE.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {第几次复活}
	self.rmb = reader:readInt16Unsigned() -- {需花费的金元数量}
end

-- {第几次复活}
function ACK_CAMPWAR_DIE.getCount(self)
	return self.count
end

-- {需花费的金元数量}
function ACK_CAMPWAR_DIE.getRmb(self)
	return self.rmb
end
