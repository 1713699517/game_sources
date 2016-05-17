
require "common/AcknowledgementMessage"

-- (手动) -- [5300]场景广播-称号 -- 场景 

ACK_SCENE_CHANGE_TITLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_TITLE
	self:init()
end)

function ACK_SCENE_CHANGE_TITLE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.title_id = reader:readInt16Unsigned() -- {称号ID}
end

-- {玩家UID}
function ACK_SCENE_CHANGE_TITLE.getUid(self)
	return self.uid
end

-- {称号ID}
function ACK_SCENE_CHANGE_TITLE.getTitleId(self)
	return self.title_id
end
