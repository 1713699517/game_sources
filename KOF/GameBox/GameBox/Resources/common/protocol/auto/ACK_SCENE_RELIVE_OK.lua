
require "common/AcknowledgementMessage"

-- [5180]玩家复活成功 -- 场景 

ACK_SCENE_RELIVE_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_RELIVE_OK
	self:init()
end)
