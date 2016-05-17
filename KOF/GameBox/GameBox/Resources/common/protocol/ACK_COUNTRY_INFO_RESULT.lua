
require "common/AcknowledgementMessage"

-- [14002]阵营信息 -- 阵营 

ACK_COUNTRY_INFO_RESULT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COUNTRY_INFO_RESULT
	self:init()
end)

-- {是否有数据 false:没 true:有 (选择)}
function ACK_COUNTRY_INFO_RESULT.getIsData(self)
	return self.is_data
end

-- {服务器ID}
function ACK_COUNTRY_INFO_RESULT.getSid(self)
	return self.sid
end

-- {阵营类型(见常量)}
function ACK_COUNTRY_INFO_RESULT.getCountryId(self)
	return self.country_id
end

-- {阵营人数}
function ACK_COUNTRY_INFO_RESULT.getNum(self)
	return self.num
end

-- {阵营综合实力}
function ACK_COUNTRY_INFO_RESULT.getPowerful(self)
	return self.powerful
end

-- {阵营资源}
function ACK_COUNTRY_INFO_RESULT.getResource(self)
	return self.resource
end

-- {职位数量}
function ACK_COUNTRY_INFO_RESULT.getPostCount(self)
	return self.post_count
end

-- {职位类型(见常量)}
function ACK_COUNTRY_INFO_RESULT.getPostType(self)
	return self.post_type
end

-- {职位UID}
function ACK_COUNTRY_INFO_RESULT.getPostUid(self)
	return self.post_uid
end

-- {职位昵称}
function ACK_COUNTRY_INFO_RESULT.getPostName(self)
	return self.post_name
end

-- {公告}
function ACK_COUNTRY_INFO_RESULT.getNotice(self)
	return self.notice
end
