
require "common/AcknowledgementMessage"

-- (手动) -- [3401]掷骰子任务数据返回(最新) -- 任务 

ACK_TASK_RAND_DATA_RETURN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_RAND_DATA_RETURN
	self:init()
end)

function ACK_TASK_RAND_DATA_RETURN.deserialize(self, reader)
	self.node = reader:readInt16Unsigned() -- {当前所在节点位置}
	self.node2 = reader:readInt16Unsigned() -- {当前事件和描述节点}
	self.left = reader:readInt16Unsigned() -- {今天剩余次数}
	self.rand = reader:readInt8Unsigned() -- {骰子步数(0则为无)}
	self.side = reader:readBoolean() -- {false:后退 | true:前进}
	self.is_have = reader:readBoolean() -- {是否有任务: false无|true有}
	self.state = reader:readBoolean() -- {true:已完成|false:未完成(is_have为true才有效)}
	self.value = reader:readInt16Unsigned() -- {进度值}
end

-- {当前所在节点位置}
function ACK_TASK_RAND_DATA_RETURN.getNode(self)
	return self.node
end

-- {当前事件和描述节点}
function ACK_TASK_RAND_DATA_RETURN.getNode2(self)
	return self.node2
end

-- {今天剩余次数}
function ACK_TASK_RAND_DATA_RETURN.getLeft(self)
	return self.left
end

-- {骰子步数(0则为无)}
function ACK_TASK_RAND_DATA_RETURN.getRand(self)
	return self.rand
end

-- {false:后退 | true:前进}
function ACK_TASK_RAND_DATA_RETURN.getSide(self)
	return self.side
end

-- {是否有任务: false无|true有}
function ACK_TASK_RAND_DATA_RETURN.getIsHave(self)
	return self.is_have
end

-- {true:已完成|false:未完成(is_have为true才有效)}
function ACK_TASK_RAND_DATA_RETURN.getState(self)
	return self.state
end

-- {进度值}
function ACK_TASK_RAND_DATA_RETURN.getValue(self)
	return self.value
end
