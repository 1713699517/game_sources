
require "common/RequestMessage"

-- [23830]挑战 -- 逐鹿台 

REQ_ARENA_BATTLE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_BATTLE
	self:init(1 ,{ 23831,700 })
end)

function REQ_ARENA_BATTLE.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID}
	writer:writeInt16Unsigned(self.rank)  -- {玩家排名}
end

function REQ_ARENA_BATTLE.setArguments(self,uid,rank)
	self.uid = uid  -- {玩家UID}
	self.rank = rank  -- {玩家排名}
end

-- {玩家UID}
function REQ_ARENA_BATTLE.setUid(self, uid)
	self.uid = uid
end
function REQ_ARENA_BATTLE.getUid(self)
	return self.uid
end

-- {玩家排名}
function REQ_ARENA_BATTLE.setRank(self, rank)
	self.rank = rank
end
function REQ_ARENA_BATTLE.getRank(self)
	return self.rank
end
