
require "common/AcknowledgementMessage"

-- [21135]所有怪物数据返回 -- 活动-保卫经书 

ACK_DEFEND_BOOK_OK_MONST_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_OK_MONST_DATA
	self:init()
end)

-- {第几波怪物}
function ACK_DEFEND_BOOK_OK_MONST_DATA.getNum(self)
	return self.num
end

-- {数量}
function ACK_DEFEND_BOOK_OK_MONST_DATA.getCount(self)
	return self.count
end

-- {怪物组协议块【21136】}
function ACK_DEFEND_BOOK_OK_MONST_DATA.getMonstData(self)
	return self.monst_data
end
