
require "common/AcknowledgementMessage"

-- [7865]登陆提醒挂机 -- 副本 

ACK_COPY_LOGIN_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_LOGIN_NOTICE
	self:init()
end)

function ACK_COPY_LOGIN_NOTICE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.nowtimes = reader:readInt16Unsigned() -- {第几轮}
	self.sumtimes = reader:readInt16Unsigned() -- {总共多少轮}
	self.time = reader:readInt32Unsigned() -- {剩余挂机时间(秒)}
	self.use_all = reader:readInt8Unsigned() -- {是否用完所有体力(0：不 | 1：是)}
	self.count = reader:readInt16Unsigned() -- {挂机历史次数}
	self.data = {} --reader:readXXXGroup() -- {挂机历史信息块}
    local iCount = 1
    while iCount <= self.count do
        local tempData = ACK_COPY_UP_RESULT()
        tempData :deserialize( reader)
        self.data[iCount] = tempData
        iCount = iCount + 1
    end
end

-- {副本ID}
function ACK_COPY_LOGIN_NOTICE.getCopyId(self)
	return self.copy_id
end

-- {第几轮}
function ACK_COPY_LOGIN_NOTICE.getNowtimes(self)
	return self.nowtimes
end

-- {总共多少轮}
function ACK_COPY_LOGIN_NOTICE.getSumtimes(self)
	return self.sumtimes
end

-- {剩余挂机时间(秒)}
function ACK_COPY_LOGIN_NOTICE.getTime(self)
	return self.time
end

-- {是否用完所有体力(0：不 | 1：是)}
function ACK_COPY_LOGIN_NOTICE.getUseAll(self)
	return self.use_all
end

-- {挂机历史次数}
function ACK_COPY_LOGIN_NOTICE.getCount(self)
	return self.count
end

-- {挂机历史信息块}
function ACK_COPY_LOGIN_NOTICE.getData(self)
	return self.data
end
