
require "common/AcknowledgementMessage"

-- [54900]竞猜状态 -- 格斗之王 

ACK_WRESTLE_GUESS_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_GUESS_STATE
	self:init()
end)

function ACK_WRESTLE_GUESS_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1:成功2:没有参加竞猜}
	self.name1 = reader:readString() -- {名字1}
	self.name2 = reader:readString() -- {名字2}
	self.rmb = reader:readInt32Unsigned() -- {下注钻石}
end

-- {1:成功2:没有参加竞猜}
function ACK_WRESTLE_GUESS_STATE.getState(self)
	return self.state
end

-- {名字1}
function ACK_WRESTLE_GUESS_STATE.getName1(self)
	return self.name1
end

-- {名字2}
function ACK_WRESTLE_GUESS_STATE.getName2(self)
	return self.name2
end

-- {下注钻石}
function ACK_WRESTLE_GUESS_STATE.getRmb(self)
	return self.rmb
end
