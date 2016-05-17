
require "common/AcknowledgementMessage"

-- [50250]牌语信息块 -- 风林山火 

ACK_FLSH_PAI_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FLSH_PAI_DATA
	self:init()
end)

function ACK_FLSH_PAI_DATA.deserialize(self, reader)
	self.pos = reader:readInt8Unsigned() -- {牌的位置}
	self.num = reader:readInt8Unsigned() -- {牌的数字}
end

-- {牌的位置}
function ACK_FLSH_PAI_DATA.getPos(self)
	return self.pos
end

-- {牌的数字}
function ACK_FLSH_PAI_DATA.getNum(self)
	return self.num
end
