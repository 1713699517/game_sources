
require "common/RequestMessage"

-- [22900]式神幻化 -- 宠物 

REQ_PET_HUANHUA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_HUANHUA
	self:init(1 ,{ 22950,700 })
end)

function REQ_PET_HUANHUA.serialize(self, writer)
	writer:writeInt16Unsigned(self.id)  -- {皮肤id}
end

function REQ_PET_HUANHUA.setArguments(self,id)
	self.id = id  -- {皮肤id}
end

-- {皮肤id}
function REQ_PET_HUANHUA.setId(self, id)
	self.id = id
end
function REQ_PET_HUANHUA.getId(self)
	return self.id
end
