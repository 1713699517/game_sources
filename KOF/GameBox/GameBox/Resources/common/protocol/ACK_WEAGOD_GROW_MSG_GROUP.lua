
require "common/AcknowledgementMessage"

-- [32075]成长记录信息块 -- 财神 

ACK_WEAGOD_GROW_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_GROW_MSG_GROUP
	self:init()
end)

-- {成长类型：见财神常量}
function ACK_WEAGOD_GROW_MSG_GROUP.getType(self)
	return self.type
end

-- {上香次数(自己上香)}
function ACK_WEAGOD_GROW_MSG_GROUP.getCenNum(self)
	return self.cen_num
end

-- {财气多少(自己上香)}
function ACK_WEAGOD_GROW_MSG_GROUP.getCenWealth(self)
	return self.cen_wealth
end

-- {长到多少级(财神升级)}
function ACK_WEAGOD_GROW_MSG_GROUP.getUpLv(self)
	return self.up_lv
end

-- {得到多少财神符(财神升级)}
function ACK_WEAGOD_GROW_MSG_GROUP.getProNum(self)
	return self.pro_num
end

-- {好友名称(好友上香)}
function ACK_WEAGOD_GROW_MSG_GROUP.getFriName(self)
	return self.fri_name
end

-- {财气多少(好友上香)}
function ACK_WEAGOD_GROW_MSG_GROUP.getFriWealth(self)
	return self.fri_wealth
end
