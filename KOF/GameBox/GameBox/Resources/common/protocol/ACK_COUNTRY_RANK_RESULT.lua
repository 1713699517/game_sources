
require "common/AcknowledgementMessage"

-- [14035]阵营排名结果 -- 阵营 

ACK_COUNTRY_RANK_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_RANK_RESULT
	self:init()
end)

-- {数量}
function ACK_COUNTRY_RANK_RESULT.getCount(self)
	return self.count
end

-- {名次}
function ACK_COUNTRY_RANK_RESULT.getIdx(self)
	return self.idx
end

-- {服务器ID}
function ACK_COUNTRY_RANK_RESULT.getSid(self)
	return self.sid
end

-- {阵营类型(见常量)}
function ACK_COUNTRY_RANK_RESULT.getCountryId(self)
	return self.country_id
end

-- {排名值}
function ACK_COUNTRY_RANK_RESULT.getValue(self)
	return self.value
end
