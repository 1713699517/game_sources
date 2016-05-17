
require "common/RequestMessage"

-- [43631]巅峰之战 -- 跨服战 

REQ_STRIDE_SUPERIOR_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_SUPERIOR_WAR
	self:init(0, nil)
end)

function REQ_STRIDE_SUPERIOR_WAR.serialize(self, writer)
	writer:writeInt16Unsigned(self.rank)  -- {排名}
end

function REQ_STRIDE_SUPERIOR_WAR.setArguments(self,rank)
	self.rank = rank  -- {排名}
end

-- {排名}
function REQ_STRIDE_SUPERIOR_WAR.setRank(self, rank)
	self.rank = rank
end
function REQ_STRIDE_SUPERIOR_WAR.getRank(self)
	return self.rank
end
