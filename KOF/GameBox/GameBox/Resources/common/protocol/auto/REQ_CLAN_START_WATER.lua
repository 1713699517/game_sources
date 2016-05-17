
require "common/RequestMessage"

-- [33325]请求开始浇水|摇钱 -- 社团 

REQ_CLAN_START_WATER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_START_WATER
	self:init(1 ,{ 33330,700 })
end)

function REQ_CLAN_START_WATER.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {类型 1 浇水| 2摇钱}
	writer:writeInt8Unsigned(self.type_act)  -- {浇水类别[1清水|2甘泉|3清风露，0摇钱]}
end

function REQ_CLAN_START_WATER.setArguments(self,type,type_act)
	self.type = type  -- {类型 1 浇水| 2摇钱}
	self.type_act = type_act  -- {浇水类别[1清水|2甘泉|3清风露，0摇钱]}
end

-- {类型 1 浇水| 2摇钱}
function REQ_CLAN_START_WATER.setType(self, type)
	self.type = type
end
function REQ_CLAN_START_WATER.getType(self)
	return self.type
end

-- {浇水类别[1清水|2甘泉|3清风露，0摇钱]}
function REQ_CLAN_START_WATER.setTypeAct(self, type_act)
	self.type_act = type_act
end
function REQ_CLAN_START_WATER.getTypeAct(self)
	return self.type_act
end
