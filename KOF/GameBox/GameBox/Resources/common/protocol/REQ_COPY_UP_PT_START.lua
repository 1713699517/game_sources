
require "common/RequestMessage"

-- (手动) -- [7870]挂机-普通副本开始挂机 -- 副本 

REQ_COPY_UP_PT_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_PT_START
	self:init()
end)

function REQ_COPY_UP_PT_START.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
	writer:writeInt8Unsigned(self.use_all)  -- {是否用完所有精力(0：不 | 1：是)}
	writer:writeInt16Unsigned(self.num)  -- {挂机次数}
end

function REQ_COPY_UP_PT_START.setArguments(self,copy_id,use_all,num)
	self.copy_id = copy_id  -- {副本ID}
	self.use_all = use_all  -- {是否用完所有精力(0：不 | 1：是)}
	self.num = num  -- {挂机次数}
end

-- {副本ID}
function REQ_COPY_UP_PT_START.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_UP_PT_START.getCopyId(self)
	return self.copy_id
end

-- {是否用完所有精力(0：不 | 1：是)}
function REQ_COPY_UP_PT_START.setUseAll(self, use_all)
	self.use_all = use_all
end
function REQ_COPY_UP_PT_START.getUseAll(self)
	return self.use_all
end

-- {挂机次数}
function REQ_COPY_UP_PT_START.setNum(self, num)
	self.num = num
end
function REQ_COPY_UP_PT_START.getNum(self)
	return self.num
end
