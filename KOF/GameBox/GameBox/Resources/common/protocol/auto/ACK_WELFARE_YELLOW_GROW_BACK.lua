
require "common/AcknowledgementMessage"

-- [22290]黄钻成长数据 -- 福利 

ACK_WELFARE_YELLOW_GROW_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_YELLOW_GROW_BACK
	self:init()
end)

function ACK_WELFARE_YELLOW_GROW_BACK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {已领取的成长礼包数量}
	self.lv = reader:readInt16Unsigned() -- {领取的成长礼包等级}
end

-- {已领取的成长礼包数量}
function ACK_WELFARE_YELLOW_GROW_BACK.getCount(self)
	return self.count
end

-- {领取的成长礼包等级}
function ACK_WELFARE_YELLOW_GROW_BACK.getLv(self)
	return self.lv
end
