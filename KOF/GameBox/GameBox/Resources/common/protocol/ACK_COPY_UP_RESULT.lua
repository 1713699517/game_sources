
require "common/AcknowledgementMessage"

-- [7850]挂机返回 -- 副本 

ACK_COPY_UP_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_RESULT
	self:init()
end)

function ACK_COPY_UP_RESULT.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.nowtimes = reader:readInt16Unsigned() -- {第几轮}
	self.sumtimes = reader:readInt16Unsigned() -- {总共多少轮}
	self.exp = reader:readInt32Unsigned() -- {经验}
	self.gold = reader:readInt32Unsigned() -- {美刀}
	self.power = reader:readInt32Unsigned() -- {潜能}
	self.count = reader:readInt16Unsigned() -- {物品数量}
	--self.data = reader:readXXXGroup() -- {物品信息块(7805)}
    self.data = nil
    if self.count >= 0 then
        self.data = {}
        local iConut = 1
        while iConut <= self.count do
            self.data[iConut] = {}
            self.data[iConut].goods_id = reader:readInt16Unsigned()
            self.data[iConut].count = reader:readInt16Unsigned()
            iConut = iConut + 1
        end
    end
    
    print("ACK_COPY_UP_RESULT.deserialize----------",self.copy_id,self.nowtimes,self.sumtimes,self.count)
end

-- {副本ID}
function ACK_COPY_UP_RESULT.getCopyId(self)
	return self.copy_id
end

-- {第几轮}
function ACK_COPY_UP_RESULT.getNowtimes(self)
	return self.nowtimes
end

-- {总共多少轮}
function ACK_COPY_UP_RESULT.getSumtimes(self)
	return self.sumtimes
end

-- {经验}
function ACK_COPY_UP_RESULT.getExp(self)
	return self.exp
end

-- {美刀}
function ACK_COPY_UP_RESULT.getGold(self)
	return self.gold
end

-- {潜能}
function ACK_COPY_UP_RESULT.getPower(self)
	return self.power
end

-- {物品数量}
function ACK_COPY_UP_RESULT.getCount(self)
	return self.count
end

-- {物品信息块(7805)}
function ACK_COPY_UP_RESULT.getData(self)
	return self.data
end
