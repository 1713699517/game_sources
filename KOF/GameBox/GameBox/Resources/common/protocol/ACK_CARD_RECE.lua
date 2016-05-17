
require "common/AcknowledgementMessage"

-- (手动) -- [24970]以领取的活动Id -- 新手卡 

ACK_CARD_RECE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_RECE
	self:init()
end)

function ACK_CARD_RECE.deserialize(self, reader)
    print("-----ACK_CARD_RECE.deserialize------")

	self.count = reader:readInt16Unsigned() -- {数量}
	self.data = {} --reader:readXXXGroup() -- {信息快(24980)}
    
    local iCount = 1
    while iCount <= self.count do
        self.data[iCount] = {}
        self.data[iCount].idstep = reader:readInt16Unsigned()
        
        
        print("领取subId->"..self.data[iCount].idstep)
        iCount = iCount + 1
    end
    
    
end

-- {数量}
function ACK_CARD_RECE.getCount(self)
	return self.count
end

-- {信息快(24980)}
function ACK_CARD_RECE.getData(self)
	return self.data
end
