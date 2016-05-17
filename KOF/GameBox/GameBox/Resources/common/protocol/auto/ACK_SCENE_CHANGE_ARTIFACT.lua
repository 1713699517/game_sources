
require "common/AcknowledgementMessage"

-- [5310]场景广播-神器 -- 场景 

ACK_SCENE_CHANGE_ARTIFACT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_CHANGE_ARTIFACT
	self:init()
end)

function ACK_SCENE_CHANGE_ARTIFACT.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.artifact_id = reader:readInt32Unsigned() -- {神器ID}
end

-- {玩家UID}
function ACK_SCENE_CHANGE_ARTIFACT.getUid(self)
	return self.uid
end

-- {神器ID}
function ACK_SCENE_CHANGE_ARTIFACT.getArtifactId(self)
	return self.artifact_id
end
