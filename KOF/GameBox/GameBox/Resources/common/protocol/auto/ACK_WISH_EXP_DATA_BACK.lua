
require "common/AcknowledgementMessage"

-- [10032]祝福经验信息返回 -- 祝福 

ACK_WISH_EXP_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_EXP_DATA_BACK
	self:init()
end)

function ACK_WISH_EXP_DATA_BACK.deserialize(self, reader)
	self.lv = reader:readInt16Unsigned() -- {领取等级}
	self.exp = reader:readInt32Unsigned() -- {可领取经验}
	self.bget = reader:readInt8Unsigned() -- {是否可以领取(1:可领取 0:不可以)}
end

-- {领取等级}
function ACK_WISH_EXP_DATA_BACK.getLv(self)
	return self.lv
end

-- {可领取经验}
function ACK_WISH_EXP_DATA_BACK.getExp(self)
	return self.exp
end

-- {是否可以领取(1:可领取 0:不可以)}
function ACK_WISH_EXP_DATA_BACK.getBget(self)
	return self.bget
end
