
require "common/AcknowledgementMessage"

-- [800]系统通知 -- 系统 

ACK_SYSTEM_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_NOTICE
	self:init()
end)

function ACK_SYSTEM_NOTICE.deserialize(self, reader)
	self.show_time = reader:readInt32Unsigned() -- {显示时长(小于默认时长或于最大,为默认时长)<br />见常量:CONST_NOTICE_SHOW_*}
	self.position = reader:readInt16Unsigned() -- {位置类型(见:CONST_BROAD_AREA_*)}
	self.msg_data = reader:readUTF() -- {消息内容}
end

-- {显示时长(小于默认时长或于最大,为默认时长)<br />见常量:CONST_NOTICE_SHOW_*}
function ACK_SYSTEM_NOTICE.getShowTime(self)
	return self.show_time
end

-- {位置类型(见:CONST_BROAD_AREA_*)}
function ACK_SYSTEM_NOTICE.getPosition(self)
	return self.position
end

-- {消息内容}
function ACK_SYSTEM_NOTICE.getMsgData(self)
	return self.msg_data
end
