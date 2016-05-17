
require "common/AcknowledgementMessage"

-- [3225]任务剧情通知 -- 任务 

ACK_TASK_TASK_DRAMA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_TASK_DRAMA
	self:init()
end)

function ACK_TASK_TASK_DRAMA.deserialize(self, reader)
	self.drama_id = reader:readInt16Unsigned() -- {剧情ID}
end

-- {剧情ID}
function ACK_TASK_TASK_DRAMA.getDramaId(self)
	return self.drama_id
end
