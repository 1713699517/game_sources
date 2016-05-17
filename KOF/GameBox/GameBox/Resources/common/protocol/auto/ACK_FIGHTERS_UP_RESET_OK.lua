
require "common/AcknowledgementMessage"

-- [55970]重置挂机成功 -- 拳皇生涯 

ACK_FIGHTERS_UP_RESET_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_UP_RESET_OK
	self:init()
end)

function ACK_FIGHTERS_UP_RESET_OK.deserialize(self, reader)
	self.reset_times = reader:readInt16Unsigned() -- {剩余重置次数}
	self.reis_mon = reader:readInt8Unsigned() -- {重置是否免费(1:免费|0:不免费)}
	self.up_is = reader:readInt8Unsigned() -- {挂机状态 详见：CONST_FIGHTERS_UP*}
	self.up_chap = reader:readInt16Unsigned() -- {当前挂机章节}
	self.up_copy = reader:readInt16Unsigned() -- {当前挂机副本}
end

-- {剩余重置次数}
function ACK_FIGHTERS_UP_RESET_OK.getResetTimes(self)
	return self.reset_times
end

-- {重置是否免费(1:免费|0:不免费)}
function ACK_FIGHTERS_UP_RESET_OK.getReisMon(self)
	return self.reis_mon
end

-- {挂机状态 详见：CONST_FIGHTERS_UP*}
function ACK_FIGHTERS_UP_RESET_OK.getUpIs(self)
	return self.up_is
end

-- {当前挂机章节}
function ACK_FIGHTERS_UP_RESET_OK.getUpChap(self)
	return self.up_chap
end

-- {当前挂机副本}
function ACK_FIGHTERS_UP_RESET_OK.getUpCopy(self)
	return self.up_copy
end
