
require "common/AcknowledgementMessage"

-- [21200]请求战壕结果 -- 活动-保卫经书 

ACK_DEFEND_BOOK_OK_TRENCH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_OK_TRENCH
	self:init()
end)

function ACK_DEFEND_BOOK_OK_TRENCH.deserialize(self, reader)
	self.num = reader:readInt8Unsigned() -- {战壕编号：1-9}
	self.count = reader:readInt16Unsigned() -- {已更换战壕次数}
	self.rmb = reader:readInt8Unsigned() -- {下次更换战壕需消耗的金元数}
end

-- {战壕编号：1-9}
function ACK_DEFEND_BOOK_OK_TRENCH.getNum(self)
	return self.num
end

-- {已更换战壕次数}
function ACK_DEFEND_BOOK_OK_TRENCH.getCount(self)
	return self.count
end

-- {下次更换战壕需消耗的金元数}
function ACK_DEFEND_BOOK_OK_TRENCH.getRmb(self)
	return self.rmb
end
