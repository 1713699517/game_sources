
require "common/AcknowledgementMessage"

-- [6140]战斗数据(展示) -- 战斗 

ACK_WAR_DATA_RE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_DATA_RE
	self:init()
end)

-- {战斗数据块 见：6020}
function ACK_WAR_DATA_RE.getGroupXxx(self)
	return self.group_xxx
end
