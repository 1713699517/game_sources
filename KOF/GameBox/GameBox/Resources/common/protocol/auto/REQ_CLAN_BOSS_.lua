
require "common/RequestMessage"

-- (手动) -- [54220]社团B -- 社团BOSS 

REQ_CLAN_BOSS_ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_
	self:init()
end)
