
require "common/AcknowledgementMessage"

-- [22280]黄钻每日面板数据 -- 福利 

ACK_WELFARE_YELLOW_DAY_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_YELLOW_DAY_BACK
	self:init()
end)

function ACK_WELFARE_YELLOW_DAY_BACK.deserialize(self, reader)
	self.yellow_day = reader:readInt8Unsigned() -- {黄钻每日奖励领取（0：未领取，1：领取过了）}
	self.yellow_common_gift = reader:readInt8Unsigned() -- {普通黄钻新手礼包（0：未领取，1：领取过了）}
	self.yellow_year_gift = reader:readInt8Unsigned() -- {年费黄钻礼包（0：未领取，1：领取过了）}
end

-- {黄钻每日奖励领取（0：未领取，1：领取过了）}
function ACK_WELFARE_YELLOW_DAY_BACK.getYellowDay(self)
	return self.yellow_day
end

-- {普通黄钻新手礼包（0：未领取，1：领取过了）}
function ACK_WELFARE_YELLOW_DAY_BACK.getYellowCommonGift(self)
	return self.yellow_common_gift
end

-- {年费黄钻礼包（0：未领取，1：领取过了）}
function ACK_WELFARE_YELLOW_DAY_BACK.getYellowYearGift(self)
	return self.yellow_year_gift
end
