
require "common/AcknowledgementMessage"

-- [7710]进入副本场景返回信息(待删除) -- 副本 

ACK_COPY_ENTER_SCENE_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_ENTER_SCENE_INFO
	self:init()
end)

function ACK_COPY_ENTER_SCENE_INFO.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.scene_sum = reader:readInt8Unsigned() -- {场景总数}
	self.scene_idx = reader:readInt8Unsigned() -- {场景索引}
end

-- {副本ID}
function ACK_COPY_ENTER_SCENE_INFO.getCopyId(self)
	return self.copy_id
end

-- {场景总数}
function ACK_COPY_ENTER_SCENE_INFO.getSceneSum(self)
	return self.scene_sum
end

-- {场景索引}
function ACK_COPY_ENTER_SCENE_INFO.getSceneIdx(self)
	return self.scene_idx
end
