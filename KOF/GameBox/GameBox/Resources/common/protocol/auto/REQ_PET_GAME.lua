
require "common/RequestMessage"

-- (手动) -- [23000]宠物游戏 -- 宠物 

REQ_PET_GAME = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_GAME
	self:init()
end)

function REQ_PET_GAME.serialize(self, writer)
	writer:writeInt32Unsigned(self.puid)  -- {宠物唯一ID}
	writer:writeInt8Unsigned(self.type)  -- {游戏类型}
end

function REQ_PET_GAME.setArguments(self,puid,type)
	self.puid = puid  -- {宠物唯一ID}
	self.type = type  -- {游戏类型}
end

-- {宠物唯一ID}
function REQ_PET_GAME.setPuid(self, puid)
	self.puid = puid
end
function REQ_PET_GAME.getPuid(self)
	return self.puid
end

-- {游戏类型}
function REQ_PET_GAME.setType(self, type)
	self.type = type
end
function REQ_PET_GAME.getType(self)
	return self.type
end
