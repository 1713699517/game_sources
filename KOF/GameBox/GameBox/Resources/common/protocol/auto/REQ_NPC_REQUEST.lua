
require "common/RequestMessage"

-- [26000]请求NPC -- NPC 

REQ_NPC_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_REQUEST
	self:init(0, nil)
end)

function REQ_NPC_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.npc_id)  -- {NPCID}
	writer:writeInt8Unsigned(self.fun_flag)  -- {NPC功能标识}
end

function REQ_NPC_REQUEST.setArguments(self,npc_id,fun_flag)
	self.npc_id = npc_id  -- {NPCID}
	self.fun_flag = fun_flag  -- {NPC功能标识}
end

-- {NPCID}
function REQ_NPC_REQUEST.setNpcId(self, npc_id)
	self.npc_id = npc_id
end
function REQ_NPC_REQUEST.getNpcId(self)
	return self.npc_id
end

-- {NPC功能标识}
function REQ_NPC_REQUEST.setFunFlag(self, fun_flag)
	self.fun_flag = fun_flag
end
function REQ_NPC_REQUEST.getFunFlag(self)
	return self.fun_flag
end
