
require "common/RequestMessage"

-- [50260]换牌 -- 风林山火 

REQ_FLSH_PAI_SWITCH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FLSH_PAI_SWITCH
	self:init()
end)

function REQ_FLSH_PAI_SWITCH.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)  -- {牌语数量}
    
    local i = 0
    if self.data ~= nil and self.count > 0 then
        for k=1 ,#self.data do
            i = i + 1
			if i > self.count then
				break
			end
            writer:writeInt8Unsigned( self.data[k] )
        end
    end
	--writer:writeXXXGroup(self.data)  -- {牌语信息块(50270)}
end

function REQ_FLSH_PAI_SWITCH.setArguments(self,count,data)
	self.count = count  -- {牌语数量}
	self.data = data  -- {牌语信息块(50270)}
end

-- {牌语数量}
function REQ_FLSH_PAI_SWITCH.setCount(self, count)
	self.count = count
end
function REQ_FLSH_PAI_SWITCH.getCount(self)
	return self.count
end

-- {牌语信息块(50270)}
function REQ_FLSH_PAI_SWITCH.setData(self, data)
	self.data = data
end
function REQ_FLSH_PAI_SWITCH.getData(self)
	return self.data
end
