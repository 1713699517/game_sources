
require "common/RequestMessage"

-- [23840]挑战结束 -- 逐鹿台 

REQ_ARENA_FINISH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_FINISH
	self:init(1 ,{ 23835,23850 })
end)

function REQ_ARENA_FINISH.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID}
	writer:writeInt32Unsigned(self.ranking)  -- {被挑战人物排名}
	writer:writeInt8Unsigned(self.res)  -- {结果1:胜利 0:失败}
end

function REQ_ARENA_FINISH.setArguments(self,uid,ranking,res)
	self.uid = uid  -- {玩家UID}
	self.ranking = ranking  -- {被挑战人物排名}
	self.res = res  -- {结果1:胜利 0:失败}
end

-- {玩家UID}
function REQ_ARENA_FINISH.setUid(self, uid)
	self.uid = uid
end
function REQ_ARENA_FINISH.getUid(self)
	return self.uid
end

-- {被挑战人物排名}
function REQ_ARENA_FINISH.setRanking(self, ranking)
	self.ranking = ranking
end
function REQ_ARENA_FINISH.getRanking(self)
	return self.ranking
end

-- {结果1:胜利 0:失败}
function REQ_ARENA_FINISH.setRes(self, res)
	self.res = res
end
function REQ_ARENA_FINISH.getRes(self)
	return self.res
end
