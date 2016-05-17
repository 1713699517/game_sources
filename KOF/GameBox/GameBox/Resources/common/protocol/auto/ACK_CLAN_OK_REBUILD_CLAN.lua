
require "common/AcknowledgementMessage"

-- [33060]创建成功 -- 社团 

ACK_CLAN_OK_REBUILD_CLAN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_REBUILD_CLAN
	self:init()
end)
