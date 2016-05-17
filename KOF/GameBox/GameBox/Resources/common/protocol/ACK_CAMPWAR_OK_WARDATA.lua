
require "common/AcknowledgementMessage"

-- [45810]战报数据返回 -- 活动-阵营战 

ACK_CAMPWAR_OK_WARDATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_OK_WARDATA
	self:init()
end)

-- {战报类型：CONST_CAMPWAR_WARDATA_TYPE_*}
function ACK_CAMPWAR_OK_WARDATA.getWtype(self)
	return self.wtype
end

-- {数量}
function ACK_CAMPWAR_OK_WARDATA.getCount(self)
	return self.count
end

-- {战报信息块【45755】}
function ACK_CAMPWAR_OK_WARDATA.getWardata(self)
	return self.wardata
end
