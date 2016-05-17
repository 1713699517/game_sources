
require "common/AcknowledgementMessage"

-- [12155]坐骑培养结果 -- 坐骑 

ACK_MOUNT_CUL_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_CUL_RESULT
	self:init()
end)

function ACK_MOUNT_CUL_RESULT.deserialize(self, reader)
	self.exp = reader:readInt32Unsigned() -- {增加多少经验}
	self.dart = reader:readInt16Unsigned() -- {突进多少次}
	self.breach = reader:readInt16Unsigned() -- {突破多少次}
end

-- {增加多少经验}
function ACK_MOUNT_CUL_RESULT.getExp(self)
	return self.exp
end

-- {突进多少次}
function ACK_MOUNT_CUL_RESULT.getDart(self)
	return self.dart
end

-- {突破多少次}
function ACK_MOUNT_CUL_RESULT.getBreach(self)
	return self.breach
end
