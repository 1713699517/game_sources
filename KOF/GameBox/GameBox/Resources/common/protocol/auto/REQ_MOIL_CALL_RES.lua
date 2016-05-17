
require "common/RequestMessage"

-- [35041]战斗结果 -- 苦工 

REQ_MOIL_CALL_RES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_CALL_RES
	self:init(0, nil)
end)

function REQ_MOIL_CALL_RES.serialize(self, writer)
	writer:writeInt8Unsigned(self.type_id)  -- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*) (选择)}
	writer:writeInt32Unsigned(self.uid)  -- {玩家Uid}
	writer:writeInt8Unsigned(self.res)  -- {1:失败 0:胜利}
end

function REQ_MOIL_CALL_RES.setArguments(self,type_id,uid,res)
	self.type_id = type_id  -- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*) (选择)}
	self.uid = uid  -- {玩家Uid}
	self.res = res  -- {1:失败 0:胜利}
end

-- {1:抓捕5:反抗6:求救 (选择)(CONST_MOIL_FUNCTION*) (选择)}
function REQ_MOIL_CALL_RES.setTypeId(self, type_id)
	self.type_id = type_id
end
function REQ_MOIL_CALL_RES.getTypeId(self)
	return self.type_id
end

-- {玩家Uid}
function REQ_MOIL_CALL_RES.setUid(self, uid)
	self.uid = uid
end
function REQ_MOIL_CALL_RES.getUid(self)
	return self.uid
end

-- {1:失败 0:胜利}
function REQ_MOIL_CALL_RES.setRes(self, res)
	self.res = res
end
function REQ_MOIL_CALL_RES.getRes(self)
	return self.res
end
