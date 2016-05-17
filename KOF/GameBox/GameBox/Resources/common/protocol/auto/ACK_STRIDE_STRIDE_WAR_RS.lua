
require "common/AcknowledgementMessage"

-- [43640]挑战结果 -- 跨服战 

ACK_STRIDE_STRIDE_WAR_RS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_STRIDE_WAR_RS
	self:init()
end)

function ACK_STRIDE_STRIDE_WAR_RS.deserialize(self, reader)
	self.rs = reader:readInt8Unsigned() -- {1:胜利0:失败}
	self.jf = reader:readInt32Unsigned() -- {获得积分}
end

-- {1:胜利0:失败}
function ACK_STRIDE_STRIDE_WAR_RS.getRs(self)
	return self.rs
end

-- {获得积分}
function ACK_STRIDE_STRIDE_WAR_RS.getJf(self)
	return self.jf
end
