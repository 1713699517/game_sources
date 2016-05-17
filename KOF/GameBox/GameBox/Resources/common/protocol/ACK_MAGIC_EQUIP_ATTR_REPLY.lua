
require "common/AcknowledgementMessage"

-- (手动) -- [52310]属性返回 -- 神器 

ACK_MAGIC_EQUIP_ATTR_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_ATTR_REPLY
	self:init()
end)

function ACK_MAGIC_EQUIP_ATTR_REPLY.deserialize(self, reader)
    
    print("-----------------------------------------------------------")
    print("ACK_MAGIC_EQUIP_ATTR_REPLY.deserialize")
    
	self.money = reader:readInt32Unsigned() -- {消耗的美刀}
    self.odds  = reader:readInt16Unsigned() -- {概率}
    
	self.count1 = reader:readInt8Unsigned() -- {属性数量}
	self.msg_xxx1 = {} --reader:readXXXGroup() -- {信息块52320}
    
    print("-------------------------消耗美刀->"..self.money.."   概率->"..self.odds.."    属性数量->"..self.count1)
    local iCount = 1
    while self.count1 >= iCount do
        self.msg_xxx1[iCount] = {}
        self.msg_xxx1[iCount].type = reader:readInt16Unsigned()
        self.msg_xxx1[iCount].type_value = reader:readInt16Unsigned()
        
        print("  类型->"..self.msg_xxx1[iCount].type.."      值->"..self.msg_xxx1[iCount].type_value)
        iCount = iCount + 1
    end
    
    
    self.count2 = reader:readInt8Unsigned() -- {材料数量}
	self.msg_xxx2 = {} --reader:readXXXGroup() -- {信息块52315}
    
    
    print("----------------------材料数量->"..self.count2)
    iCount = 1
    while self.count2 >= iCount do
        self.msg_xxx2[iCount] = {}
        self.msg_xxx2[iCount].item_id = reader:readInt16Unsigned()
        self.msg_xxx2[iCount].count   = reader:readInt16Unsigned()
        
        print("   材料ID->"..self.msg_xxx2[iCount].item_id.."    数量->"..self.msg_xxx2[iCount].count)
        
        iCount = iCount + 1
    end
    
    print("-----------------------------------------------------------")
    
    
end


-- {消耗的美刀}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getMoney(self)
	return self.money
end

-- {概率}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getOdds(self)
	return self.odds
end

-- {属性数量}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getCount1(self)
	return self.count1
end

-- {信息块52320}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getMsgXxx1(self)
	return self.msg_xxx1
end

-- {材料数量}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getCount2(self)
	return self.count2
end

-- {信息块52315}
function ACK_MAGIC_EQUIP_ATTR_REPLY.getMsgXxx2(self)
	return self.msg_xxx2
end
