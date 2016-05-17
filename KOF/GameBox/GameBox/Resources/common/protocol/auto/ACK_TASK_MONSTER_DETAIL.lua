
require "common/AcknowledgementMessage"

-- [3223]怪物信息块 -- 任务 

ACK_TASK_MONSTER_DETAIL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_MONSTER_DETAIL
	self:init()
end)

function ACK_TASK_MONSTER_DETAIL.deserialize(self, reader)
	self.monster_id = reader:readInt16Unsigned() -- {怪物ID}
	self.monster_nums = reader:readInt8Unsigned() -- {怪物数量}
	self.monster_max = reader:readInt8Unsigned() -- {达成所需数量}
end

-- {怪物ID}
function ACK_TASK_MONSTER_DETAIL.getMonsterId(self)
	return self.monster_id
end

-- {怪物数量}
function ACK_TASK_MONSTER_DETAIL.getMonsterNums(self)
	return self.monster_nums
end

-- {达成所需数量}
function ACK_TASK_MONSTER_DETAIL.getMonsterMax(self)
	return self.monster_max
end
