
require "common/RequestMessage"

-- [6550]请求伙伴技能列表 -- 技能系统 

REQ_SKILL_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_PARTNER
	self:init()
end)

function REQ_SKILL_PARTNER.serialize(self, writer)
    writer:writeInt32Unsigned(self.uid)       -- {主角uid}
	writer:writeInt32Unsigned(self.parentid)  -- {伙伴id}
end

function REQ_SKILL_PARTNER.setArguments(self, uid, parentid)
    self.uid      = uid
	self.parentid = parentid  -- {伙伴id}
end

function REQ_SKILL_PARTNER.setUid( self, id )
    self.uid = id
end

function REQ_SKILL_PARTNER.getUid( self )
    return self.uid
end

-- {伙伴id}
function REQ_SKILL_PARTNER.setParentid(self, parentid)
	self.parentid = parentid
end
function REQ_SKILL_PARTNER.getParentid(self)
	return self.parentid
end
