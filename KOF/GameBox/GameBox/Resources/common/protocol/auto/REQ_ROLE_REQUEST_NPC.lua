
require "common/RequestMessage"

-- [1140]请求NPC -- 角色 

REQ_ROLE_REQUEST_NPC = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_REQUEST_NPC
	self:init(0, nil)
end)

function REQ_ROLE_REQUEST_NPC.serialize(self, writer)
	writer:writeInt16Unsigned(self.npc_id)  -- {NPCID}
	writer:writeInt8Unsigned(self.fun_flag)  -- {NPC功能标识}
end

function REQ_ROLE_REQUEST_NPC.setArguments(self,npc_id,fun_flag)
	self.npc_id = npc_id  -- {NPCID}
	self.fun_flag = fun_flag  -- {NPC功能标识}
end

-- {NPCID}
function REQ_ROLE_REQUEST_NPC.setNpcId(self, npc_id)
	self.npc_id = npc_id
end
function REQ_ROLE_REQUEST_NPC.getNpcId(self)
	return self.npc_id
end

-- {NPC功能标识}
function REQ_ROLE_REQUEST_NPC.setFunFlag(self, fun_flag)
	self.fun_flag = fun_flag
end
function REQ_ROLE_REQUEST_NPC.getFunFlag(self)
	return self.fun_flag
end
