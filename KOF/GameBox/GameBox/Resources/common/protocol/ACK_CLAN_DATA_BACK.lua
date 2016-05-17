
require "common/AcknowledgementMessage"

-- [33042]社团信息返回 -- 社团 

ACK_CLAN_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_DATA_BACK
	self:init()
end)

function ACK_CLAN_DATA_BACK.deserialize(self, reader)
	self.boolean = reader:readBoolean() -- {true:有社团|false:无}
	self.msg_xxx = reader:readXXXGroup() -- {信息块33002}
	self.count_a = reader:readInt16Unsigned() -- {申请列表数量}
	self.msg_xxx2 = reader:readXXXGroup() -- {信息块33004}
	self.count_e = reader:readInt16Unsigned() -- {日志事件数量}
	self.msg_xxx3 = reader:readXXXGroup() -- {信息块33006}
end

-- {true:有社团|false:无}
function ACK_CLAN_DATA_BACK.getBoolean(self)
	return self.boolean
end

-- {信息块33002}
function ACK_CLAN_DATA_BACK.getMsgXxx(self)
	return self.msg_xxx
end

-- {申请列表数量}
function ACK_CLAN_DATA_BACK.getCountA(self)
	return self.count_a
end

-- {信息块33004}
function ACK_CLAN_DATA_BACK.getMsgXxx2(self)
	return self.msg_xxx2
end

-- {日志事件数量}
function ACK_CLAN_DATA_BACK.getCountE(self)
	return self.count_e
end

-- {信息块33006}
function ACK_CLAN_DATA_BACK.getMsgXxx3(self)
	return self.msg_xxx3
end
