
require "common/AcknowledgementMessage"

-- [1264]请求购买面板成功 -- 角色 

ACK_ROLE_OK_ASK_BUYE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OK_ASK_BUYE
	self:init()
end)

function ACK_ROLE_OK_ASK_BUYE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {购买精力类型-[见常量CONST_ENERGY_购买精力类型]}
	self.num = reader:readInt8Unsigned() -- {第几次购买}
	self.sumnum = reader:readInt8Unsigned() -- {可购买总次数}
	self.rmb = reader:readInt16Unsigned() -- {购买需花费的元宝数}
end

-- {购买精力类型-[见常量CONST_ENERGY_购买精力类型]}
function ACK_ROLE_OK_ASK_BUYE.getType(self)
	return self.type
end

-- {第几次购买}
function ACK_ROLE_OK_ASK_BUYE.getNum(self)
	return self.num
end

-- {可购买总次数}
function ACK_ROLE_OK_ASK_BUYE.getSumnum(self)
	return self.sumnum
end

-- {购买需花费的元宝数}
function ACK_ROLE_OK_ASK_BUYE.getRmb(self)
	return self.rmb
end
