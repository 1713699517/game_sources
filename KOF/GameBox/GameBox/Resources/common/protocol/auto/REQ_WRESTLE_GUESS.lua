
require "common/RequestMessage"

-- [54890]欢乐竞猜 -- 格斗之王 

REQ_WRESTLE_GUESS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WRESTLE_GUESS
	self:init(0, nil)
end)

function REQ_WRESTLE_GUESS.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid1)  -- {冠军玩家的uid}
	writer:writeInt32Unsigned(self.uid2)  -- {亚军玩家的uid}
	writer:writeInt32Unsigned(self.rmb)  -- {下注钻石}
end

function REQ_WRESTLE_GUESS.setArguments(self,uid1,uid2,rmb)
	self.uid1 = uid1  -- {冠军玩家的uid}
	self.uid2 = uid2  -- {亚军玩家的uid}
	self.rmb = rmb  -- {下注钻石}
end

-- {冠军玩家的uid}
function REQ_WRESTLE_GUESS.setUid1(self, uid1)
	self.uid1 = uid1
end
function REQ_WRESTLE_GUESS.getUid1(self)
	return self.uid1
end

-- {亚军玩家的uid}
function REQ_WRESTLE_GUESS.setUid2(self, uid2)
	self.uid2 = uid2
end
function REQ_WRESTLE_GUESS.getUid2(self)
	return self.uid2
end

-- {下注钻石}
function REQ_WRESTLE_GUESS.setRmb(self, rmb)
	self.rmb = rmb
end
function REQ_WRESTLE_GUESS.getRmb(self)
	return self.rmb
end
