
require "common/AcknowledgementMessage"

-- [10040]好友升级提示 -- 祝福 

ACK_WISH_LV_UP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_LV_UP
	self:init()
end)

function ACK_WISH_LV_UP.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {用户id}
	self.name = reader:readString() -- {姓名}
	self.county = reader:readInt8Unsigned() -- {国家}
	self.lv = reader:readInt16Unsigned() -- {等级}
end

-- {用户id}
function ACK_WISH_LV_UP.getUid(self)
	return self.uid
end

-- {姓名}
function ACK_WISH_LV_UP.getName(self)
	return self.name
end

-- {国家}
function ACK_WISH_LV_UP.getCounty(self)
	return self.county
end

-- {等级}
function ACK_WISH_LV_UP.getLv(self)
	return self.lv
end
