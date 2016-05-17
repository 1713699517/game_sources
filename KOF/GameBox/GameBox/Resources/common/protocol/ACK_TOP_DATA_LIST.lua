
require "common/AcknowledgementMessage"

-- [24860]排行榜数据列表 -- 排行榜 

ACK_TOP_DATA_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_DATA_LIST
	self:init()
end)

function ACK_TOP_DATA_LIST.deserialize(self, reader)
	self.type            = reader:readInt8Unsigned()  -- {排行榜大类}
	self.id              = reader:readInt8Unsigned()  -- {排行榜ID}
	self.page            = reader:readInt16Unsigned() -- {当前页}
	self.page_sum        = reader:readInt16Unsigned() -- {总页数}
	self.count           = reader:readInt16Unsigned() -- {排行数量}
	self.uid             = reader:readInt32Unsigned() -- {玩家uid}
	self.yellow          = reader:readInt8Unsigned()  -- {是否黄钻}
	self.vip             = reader:readInt8Unsigned()  -- {vip等级}
	self.name            = reader:readUTF()           -- {玩家名字}    
	self.country         = reader:readInt8Unsigned()  -- {阵营}
	self.career          = reader:readInt8Unsigned()  -- {职业}
	self.sex             = reader:readInt8Unsigned()  -- {性别}    
    self.value           = reader:readInt32Unsigned() -- {排行值}
	self.clan_id         = reader:readInt32Unsigned() -- {家族ID}
	self.clan_name       = reader:readUTF()           -- {家族名字}
	self.master          = reader:readUTF()           -- {族长名字}
	self.num             = reader:readInt16Unsigned() -- {家族人数}
	self.value2          = reader:readInt32Unsigned() -- {家族等级/财富}
    self.uid2            = reader:readInt32Unsigned() -- {玩家uid}
	self.yellow2         = reader:readInt8Unsigned()  -- {是否黄钻}
	self.vip2            = reader:readInt8Unsigned()  -- {vip等级}
	self.name2           = reader:readUTF()           -- {玩家名字}    
	self.lv              = reader:readInt16Unsigned() -- {玩家等级}
	self.pet_name        = reader:readUTF()           -- {宠物名字}
	self.quality         = reader:readInt8Unsigned()  -- {品阶}
    self.power           = reader:readInt32Unsigned() -- {战斗力}
    print( "请求排行榜数据返回SSSSSSSSSSSSSSS")
    print( "self.type"..self.type.."\nself.page"..self.page.."\nself.page_sum"..self.page_sum.."\nself.count"..self.count.."\nself.name"..self.name.."\nself.value"..self.value)
end

-- {排行榜大类}
function ACK_TOP_DATA_LIST.getType(self)
	return self.type
end

-- {排行榜ID}
function ACK_TOP_DATA_LIST.getId(self)
	return self.id
end

-- {当前页}
function ACK_TOP_DATA_LIST.getPage(self)
	return self.page
end

-- {总页数}
function ACK_TOP_DATA_LIST.getPageSum(self)
	return self.page_sum
end

-- {排行数量}
function ACK_TOP_DATA_LIST.getCount(self)
	return self.count
end

-- {玩家uid}
function ACK_TOP_DATA_LIST.getUid(self)
	return self.uid
end

-- {是否黄钻}
function ACK_TOP_DATA_LIST.getYellow(self)
	return self.yellow
end

-- {vip等级}
function ACK_TOP_DATA_LIST.getVip(self)
	return self.vip
end

-- {玩家名字}
function ACK_TOP_DATA_LIST.getName(self)
	return self.name
end

-- {阵营}
function ACK_TOP_DATA_LIST.getCountry(self)
	return self.country
end

-- {职业}
function ACK_TOP_DATA_LIST.getCareer(self)
	return self.career
end

-- {性别}
function ACK_TOP_DATA_LIST.getSex(self)
	return self.sex
end

-- {排行值}
function ACK_TOP_DATA_LIST.getValue(self)
	return self.value
end

-- {家族ID}
function ACK_TOP_DATA_LIST.getClanId(self)
	return self.clan_id
end

-- {家族名字}
function ACK_TOP_DATA_LIST.getClanName(self)
	return self.clan_name
end

-- {族长名字}
function ACK_TOP_DATA_LIST.getMaster(self)
	return self.master
end

-- {家族人数}
function ACK_TOP_DATA_LIST.getNum(self)
	return self.num
end

-- {家族等级/财富}
function ACK_TOP_DATA_LIST.getValue2(self)
	return self.value2
end

-- {玩家uid}
function ACK_TOP_DATA_LIST.getUid2(self)
	return self.uid2
end

-- {是否黄钻}
function ACK_TOP_DATA_LIST.getYellow2(self)
	return self.yellow2
end

-- {vip等级}
function ACK_TOP_DATA_LIST.getVip2(self)
	return self.vip2
end

-- {玩家名字}
function ACK_TOP_DATA_LIST.getName2(self)
	return self.name2
end

-- {玩家等级}
function ACK_TOP_DATA_LIST.getLv(self)
	return self.lv
end

-- {宠物名字}
function ACK_TOP_DATA_LIST.getPetName(self)
	return self.pet_name
end

-- {品阶}
function ACK_TOP_DATA_LIST.getQuality(self)
	return self.quality
end

-- {战斗力}
function ACK_TOP_DATA_LIST.getPower(self)
	return self.power
end
