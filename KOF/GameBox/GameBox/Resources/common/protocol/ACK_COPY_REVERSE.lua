
require "common/AcknowledgementMessage"

-- [7010]副本信息返回 -- 副本 

ACK_COPY_REVERSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_REVERSE
	self:init()
end)


function ACK_COPY_REVERSE.deserialize(self, reader)
	self.count         = reader:readInt16Unsigned() -- {副本数量}
    print("FFFFFFFFFFFF副本数量：",self.count)
	--self.data = reader:readXXXGroup()
    self.data = {}   -- {副本信息返回块(7020 )}
    local icount = 1
    while icount <= self.count do
        self.data[icount] = {}
        self.data[icount].copy_id       = reader: readInt16Unsigned()
        self.data[icount].is_pass       = reader: readInt8Unsigned()
        print("FFFFFFFFFFFF副本ID：",self.data[icount].copy_id,"FFFFFFFFFFFFIs_pass:",self.data[icount].is_pass)
        icount = icount+1
    end    
end

-- {副本数量}
function ACK_COPY_REVERSE.getCount(self)
	return self.count
end

-- {副本信息块(7020)}
function ACK_COPY_REVERSE.getData(self)
	return self.data
end
