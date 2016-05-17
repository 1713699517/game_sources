
require "common/AcknowledgementMessage"

-- [54820]玩家积分返回 -- 格斗之王 

ACK_WRESTLE_XXXXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_XXXXX
	self:init()
end)

function ACK_WRESTLE_XXXXX.deserialize(self, reader)
	self.pos = reader:readInt8Unsigned() -- {位置}
	self.name = reader:readString() -- {玩家的名字}
	self.success = reader:readInt16Unsigned() -- {胜场次}
	self.fail = reader:readInt16Unsigned() -- {输场次}
	self.score = reader:readInt32Unsigned() -- {玩家积分}
end

-- {位置}
function ACK_WRESTLE_XXXXX.getPos(self)
	return self.pos
end

-- {玩家的名字}
function ACK_WRESTLE_XXXXX.getName(self)
	return self.name
end

-- {胜场次}
function ACK_WRESTLE_XXXXX.getSuccess(self)
	return self.success
end

-- {输场次}
function ACK_WRESTLE_XXXXX.getFail(self)
	return self.fail
end

-- {玩家积分}
function ACK_WRESTLE_XXXXX.getScore(self)
	return self.score
end
