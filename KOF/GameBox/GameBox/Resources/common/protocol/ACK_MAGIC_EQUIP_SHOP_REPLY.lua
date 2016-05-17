
require "common/AcknowledgementMessage"

-- [52260]神器商店返回 -- 神器 

ACK_MAGIC_EQUIP_SHOP_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_SHOP_REPLY
	self:init()
end)

function ACK_MAGIC_EQUIP_SHOP_REPLY.deserialize(self, reader)
    print("--------------ACK_MAGIC_EQUIP_SHOP_REPLY.deserialize--------------")
	self.count = reader:readInt16Unsigned() -- {数量}
	self.msg = {} -- {信息块（52270）}
    print(self.count)
    local iCount = 1 
    while iCount <= self.count do 
        self.msg[iCount] = {}
        self.msg[iCount].id    = reader:readInt32Unsigned()
        self.msg[iCount].type  = reader:readInt8Unsigned()
        self.msg[iCount].price = reader:readInt8Unsigned()
        
        print(iCount, self.msg[iCount].id, self.msg[iCount].type, self.msg[iCount].price)
        iCount = iCount + 1
    end
end

-- {数量}
function ACK_MAGIC_EQUIP_SHOP_REPLY.getCount(self)
	return self.count
end

-- {信息块（52270）}
function ACK_MAGIC_EQUIP_SHOP_REPLY.getMsg(self)
	return self.msg
end
