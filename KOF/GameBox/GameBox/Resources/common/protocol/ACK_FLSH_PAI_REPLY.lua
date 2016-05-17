
require "common/AcknowledgementMessage"

-- [50240]牌语返回 -- 风林山火 

ACK_FLSH_PAI_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FLSH_PAI_REPLY
	self:init()
end)

function ACK_FLSH_PAI_REPLY.deserialize(self, reader)
    print("--------------ACK_FLSH_PAI_REPLY.deserialize---------------")
    self.times = reader:readInt16Unsigned() -- {已换牌次数}
	self.count = reader:readInt16Unsigned() -- {牌语数量}
	self.data = {} -- {牌语信息块(50250)}
    print("times="..self.times)
    print("count="..self.count)
    local iCount = 1
    while iCount <= self.count do
        self.data[iCount] = {}
        self.data[iCount].pos = reader:readInt8Unsigned()
        self.data[iCount].num = reader:readInt8Unsigned()
        print(iCount,self.data[iCount].pos,self.data[iCount].num)
        iCount = iCount + 1
    end
    print("-----------------------------")
end

-- {已换牌次数}
function ACK_FLSH_PAI_REPLY.getTimes(self)
	return self.times
end

-- {牌语数量}
function ACK_FLSH_PAI_REPLY.getCount(self)
	return self.count
end

-- {牌语信息块(50250)}
function ACK_FLSH_PAI_REPLY.getData(self)
	return self.data
end
