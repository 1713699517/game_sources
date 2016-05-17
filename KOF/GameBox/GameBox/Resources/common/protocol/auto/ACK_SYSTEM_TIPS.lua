
require "common/AcknowledgementMessage"

-- [820]游戏提示 -- 系统 

ACK_SYSTEM_TIPS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_TIPS
	self:init()
end)

function ACK_SYSTEM_TIPS.deserialize(self, reader)
	self.type_id = reader:readInt16Unsigned() -- {提示类型}
	self.count = reader:readInt16Unsigned() -- {消息数量}
	self.tips_data = reader:readInt32() -- {提示数据}
end

-- {提示类型}
function ACK_SYSTEM_TIPS.getTypeId(self)
	return self.type_id
end

-- {消息数量}
function ACK_SYSTEM_TIPS.getCount(self)
	return self.count
end

-- {提示数据}
function ACK_SYSTEM_TIPS.getTipsData(self)
	return self.tips_data
end
