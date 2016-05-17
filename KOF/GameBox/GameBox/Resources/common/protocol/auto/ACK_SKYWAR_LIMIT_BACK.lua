
require "common/AcknowledgementMessage"

-- [40512]是否可参与天宫之战 -- 天宫之战 

ACK_SKYWAR_LIMIT_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_LIMIT_BACK
	self:init()
end)

function ACK_SKYWAR_LIMIT_BACK.deserialize(self, reader)
	self.result = reader:readBoolean() -- {true:可参加|false:不可}
	self.camp = reader:readInt8Unsigned() -- {0:守|1:攻}
	self.wall = reader:readInt8Unsigned() -- {当前是外墙1还是内墙2}
end

-- {true:可参加|false:不可}
function ACK_SKYWAR_LIMIT_BACK.getResult(self)
	return self.result
end

-- {0:守|1:攻}
function ACK_SKYWAR_LIMIT_BACK.getCamp(self)
	return self.camp
end

-- {当前是外墙1还是内墙2}
function ACK_SKYWAR_LIMIT_BACK.getWall(self)
	return self.wall
end
