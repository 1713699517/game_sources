
require "common/RequestMessage"

-- [22870]删除宠物 -- 宠物 


REQ_PET_DELETE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_DELETE
	self:init()
end)

function REQ_PET_DELETE.serialize(self, writer)
	writer:writeInt8Unsigned(self.idx)
end

function REQ_PET_DELETE.setArguments(self,idx)
	self.idx = idx
end

function REQ_PET_DELETE.getidx(self, value)
	return self.idx
end
