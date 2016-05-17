
require "common/AcknowledgementMessage"

-- [54802]返回竞技场数据 -- 格斗之王 

ACK_WRESTLE_AREANK_RANK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_AREANK_RANK
	self:init()
end)

function ACK_WRESTLE_AREANK_RANK.deserialize(self, reader)
	self.rank = reader:readInt16Unsigned() -- {竞技场排名}
end

-- {竞技场排名}
function ACK_WRESTLE_AREANK_RANK.getRank(self)
	return self.rank
end
