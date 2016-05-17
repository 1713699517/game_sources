
require "common/AcknowledgementMessage"

-- [22240]充值奖励数据 -- 福利 

ACK_WELFARE_PAY_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_PAY_BACK
	self:init()
end)

-- {累计充值克拉}
function ACK_WELFARE_PAY_BACK.getPayCumul(self)
	return self.pay_cumul
end

-- {已领的充值奖励数量}
function ACK_WELFARE_PAY_BACK.getCount(self)
	return self.count
end

-- {充值条件值}
function ACK_WELFARE_PAY_BACK.getCondition(self)
	return self.condition
end

-- {额度奖励数量}
function ACK_WELFARE_PAY_BACK.getCountLimit(self)
	return self.count_limit
end

-- {额度条件值}
function ACK_WELFARE_PAY_BACK.getLimitValue(self)
	return self.limit_value
end

-- {额度剩余值}
function ACK_WELFARE_PAY_BACK.getLimitPay(self)
	return self.limit_pay
end
