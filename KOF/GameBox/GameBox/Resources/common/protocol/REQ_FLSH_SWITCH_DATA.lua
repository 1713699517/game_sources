
require "common/RequestMessage"

-- [50270]换牌信息块 -- 风林山火 

REQ_FLSH_SWITCH_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FLSH_SWITCH_DATA
	self:init()
end)

function REQ_FLSH_SWITCH_DATA.serialize(self, writer)
	writer:writeInt8Unsigned(self.pos)  -- {牌的位置}
end

function REQ_FLSH_SWITCH_DATA.setArguments(self,pos)
	self.pos = pos  -- {牌的位置}
end

-- {牌的位置}
function REQ_FLSH_SWITCH_DATA.setPos(self, pos)
	self.pos = pos
end
function REQ_FLSH_SWITCH_DATA.getPos(self)
	return self.pos
end
