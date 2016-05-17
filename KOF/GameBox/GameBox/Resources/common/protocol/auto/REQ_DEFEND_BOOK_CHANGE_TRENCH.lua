
require "common/RequestMessage"

-- [21300]请求更换战壕 -- 活动-保卫经书 

REQ_DEFEND_BOOK_CHANGE_TRENCH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_CHANGE_TRENCH
	self:init(0, nil)
end)

function REQ_DEFEND_BOOK_CHANGE_TRENCH.serialize(self, writer)
	writer:writeInt8Unsigned(self.trench_num)  -- {新战壕编号}
end

function REQ_DEFEND_BOOK_CHANGE_TRENCH.setArguments(self,trench_num)
	self.trench_num = trench_num  -- {新战壕编号}
end

-- {新战壕编号}
function REQ_DEFEND_BOOK_CHANGE_TRENCH.setTrenchNum(self, trench_num)
	self.trench_num = trench_num
end
function REQ_DEFEND_BOOK_CHANGE_TRENCH.getTrenchNum(self)
	return self.trench_num
end
