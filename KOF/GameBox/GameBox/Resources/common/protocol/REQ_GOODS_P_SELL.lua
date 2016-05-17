
require "common/RequestMessage"

-- (手动) -- [2261]出售物品（新） -- 物品/背包

REQ_GOODS_P_SELL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_P_SELL
	self:init(1 ,{ 2262,700 })
end)

function REQ_GOODS_P_SELL.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)  -- {数量}
	--writer:writeXXXGroup(self.data)  -- {信息块2260}
	for i=1,self.count do
		local data = self.data[i]
		writer:writeInt16Unsigned(data.index)
		writer:writeInt16Unsigned(data.count)
		print(i,"--->",data.index,data.count)
	end
end

function REQ_GOODS_P_SELL.setArguments(self,count,data)
	self.count = count  -- {数量}
	self.data = data  -- {信息块2260}
end

-- {数量}
function REQ_GOODS_P_SELL.setCount(self, count)
	self.count = count
end
function REQ_GOODS_P_SELL.getCount(self)
	return self.count
end

-- {信息块2260}
function REQ_GOODS_P_SELL.setData(self, data)
	self.data = data
end
function REQ_GOODS_P_SELL.getData(self)
	return self.data
end
