
require "common/AcknowledgementMessage"

-- [49201]日常任务数据返回 -- 日常任务系统 

ACK_DAILY_TASK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DAILY_TASK_DATA
	self:init()
end)

function ACK_DAILY_TASK_DATA.deserialize(self, reader)
	self.node = reader:readInt16Unsigned() -- {当前所在节点位置}
	self.left = reader:readInt8Unsigned() -- {今天剩余次数}
    self.value = reader:readInt8Unsigned()-- {当前进度}
    self.state = reader:readInt8Unsigned()-- {任务状态}
    self.count = reader:readInt8Unsigned()-- {可以刷新次数}
    print("49201]日常任务数据返回 -- 日常任务系统", self.node, self.left, self.value, self.state, self.count)
    
end

-- {当前所在节点位置}
function ACK_DAILY_TASK_DATA.getNode(self)
	return self.node
end

-- {今天剩余次数}
function ACK_DAILY_TASK_DATA.getLeft(self)
	return self.left
end
-- {当前进度}
function ACK_DAILY_TASK_DATA.getValue(self)
	return self.value
end

-- {任务状态}
function ACK_DAILY_TASK_DATA.getState(self)
	return self.state
end
-- {可以刷新次数}
function ACK_DAILY_TASK_DATA.getCount(self)
    return self.count
end

