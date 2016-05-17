
require "common/AcknowledgementMessage"

-- (手动) -- [3402]掷骰子任务数据返回(兼容,去除) -- 任务 

ACK_TASK_RAND_DATA_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_RAND_DATA_BACK
	self:init()
end)

function ACK_TASK_RAND_DATA_BACK.deserialize(self, reader)
	self.node = reader:readInt16Unsigned() -- {当前所在节点位置}
	self.node2 = reader:readInt16Unsigned() -- {当前事件和描述节点}
	self.left = reader:readInt16Unsigned() -- {今天剩余次数}
	self.rand = reader:readInt8() -- {骰子步数(0则为无)}
	self.is_have = reader:readBoolean() -- {是否有任务: false无|true有}
	self.state = reader:readBoolean() -- {true:已完成|false:未完成(is_have为true才有效)}
end

-- {当前所在节点位置}
function ACK_TASK_RAND_DATA_BACK.getNode(self)
	return self.node
end

-- {当前事件和描述节点}
function ACK_TASK_RAND_DATA_BACK.getNode2(self)
	return self.node2
end

-- {今天剩余次数}
function ACK_TASK_RAND_DATA_BACK.getLeft(self)
	return self.left
end

-- {骰子步数(0则为无)}
function ACK_TASK_RAND_DATA_BACK.getRand(self)
	return self.rand
end

-- {是否有任务: false无|true有}
function ACK_TASK_RAND_DATA_BACK.getIsHave(self)
	return self.is_have
end

-- {true:已完成|false:未完成(is_have为true才有效)}
function ACK_TASK_RAND_DATA_BACK.getState(self)
	return self.state
end
