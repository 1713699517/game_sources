
require "common/AcknowledgementMessage"

-- (手动) -- [3403]掷骰子任务数据返回2(兼容,去除) -- 任务 

ACK_TASK_RAND_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_RAND_DATA
	self:init()
end)

function ACK_TASK_RAND_DATA.deserialize(self, reader)
	self.node = reader:readInt16Unsigned() -- {掷骰子任务数据返回}
	self.node2 = reader:readInt16Unsigned() -- {当前事件和描述节点}
	self.left = reader:readInt16Unsigned() -- {今天剩余次数}
	self.rand = reader:readInt8() -- {骰子步数(0则为无)}
	self.is_have = reader:readBoolean() -- {是否有任务: false无|true有}
	self.state = reader:readBoolean() -- {true:已完成|false:未完成(is_have为true才有效)}
	self.value = reader:readInt16Unsigned() -- {进度值}
end

-- {掷骰子任务数据返回}
function ACK_TASK_RAND_DATA.getNode(self)
	return self.node
end

-- {当前事件和描述节点}
function ACK_TASK_RAND_DATA.getNode2(self)
	return self.node2
end

-- {今天剩余次数}
function ACK_TASK_RAND_DATA.getLeft(self)
	return self.left
end

-- {骰子步数(0则为无)}
function ACK_TASK_RAND_DATA.getRand(self)
	return self.rand
end

-- {是否有任务: false无|true有}
function ACK_TASK_RAND_DATA.getIsHave(self)
	return self.is_have
end

-- {true:已完成|false:未完成(is_have为true才有效)}
function ACK_TASK_RAND_DATA.getState(self)
	return self.state
end

-- {进度值}
function ACK_TASK_RAND_DATA.getValue(self)
	return self.value
end
