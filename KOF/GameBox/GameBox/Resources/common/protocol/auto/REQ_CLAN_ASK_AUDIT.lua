
require "common/RequestMessage"

-- [33090]请求审核操作 -- 社团 

REQ_CLAN_ASK_AUDIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_AUDIT
	self:init(0, nil)
end)

function REQ_CLAN_ASK_AUDIT.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家Uid}
	writer:writeInt8Unsigned(self.state)  -- {1 true| 0 false}
end

function REQ_CLAN_ASK_AUDIT.setArguments(self,uid,state)
	self.uid = uid  -- {玩家Uid}
	self.state = state  -- {1 true| 0 false}
end

-- {玩家Uid}
function REQ_CLAN_ASK_AUDIT.setUid(self, uid)
	self.uid = uid
end
function REQ_CLAN_ASK_AUDIT.getUid(self)
	return self.uid
end

-- {1 true| 0 false}
function REQ_CLAN_ASK_AUDIT.setState(self, state)
	self.state = state
end
function REQ_CLAN_ASK_AUDIT.getState(self)
	return self.state
end
