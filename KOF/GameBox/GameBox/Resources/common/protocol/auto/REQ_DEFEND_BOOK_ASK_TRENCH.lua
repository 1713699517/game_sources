
require "common/RequestMessage"

-- [21190]请求选择战壕 -- 活动-保卫经书 

REQ_DEFEND_BOOK_ASK_TRENCH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_ASK_TRENCH
	self:init(0, nil)
end)

function REQ_DEFEND_BOOK_ASK_TRENCH.serialize(self, writer)
	writer:writeInt8Unsigned(self.num)  -- {战壕编号：1-9}
end

function REQ_DEFEND_BOOK_ASK_TRENCH.setArguments(self,num)
	self.num = num  -- {战壕编号：1-9}
end

-- {战壕编号：1-9}
function REQ_DEFEND_BOOK_ASK_TRENCH.setNum(self, num)
	self.num = num
end
function REQ_DEFEND_BOOK_ASK_TRENCH.getNum(self)
	return self.num
end
