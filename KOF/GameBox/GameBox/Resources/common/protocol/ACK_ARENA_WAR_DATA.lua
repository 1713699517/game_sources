
require "common/AcknowledgementMessage"
require "common/protocol/ACK_WAR_PLAYER_WAR"
-- [23831]战斗信息块 -- 逐鹿台

ACK_ARENA_WAR_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_WAR_DATA
	self:init()
end)

function ACK_ARENA_WAR_DATA.deserialize(self, reader)
	--self.data = reader:readXXXGroup() -- {信息块（6010）}
    self.data = ACK_WAR_PLAYER_WAR()
    self.data : deserialize(reader)

end

-- {信息块（6010）}
function ACK_ARENA_WAR_DATA.getData(self)
	return self.data
end
