
require "common/AcknowledgementMessage"

-- [810]游戏广播 -- 系统 

ACK_SYSTEM_BROADCAST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_BROADCAST
	self:init()
end)

function ACK_SYSTEM_BROADCAST.deserialize(self, reader)
    print("-- [810]游戏广播 -- 系统")
	self.broadcast_id = reader:readInt16Unsigned()  -- {消息类型}
    self.position     = reader:readInt8Unsigned()  -- {显示位置(1区,聊天|2区,喇叭|3区,广播)}
	self.msg_count    = reader:readInt16Unsigned()  -- {消息数量}
    print("消息类型: "..self.broadcast_id.."显示位置: "..self.position.."消息数量: "..self.msg_count)
	--self.data = reader:readXXXGroup() -- {斗气信息块【48203】}
    self.data = {}
    for i=1,self.msg_count do
        print("第 "..i.." 个消息:")
        local tempData = ACK_SYSTEM_DATA_XXX()
        tempData :deserialize( reader)
        self.data[i] = tempData        
    end
end


-- {显示位置(1区,聊天|2区,喇叭|3区,广播)}
function ACK_SYSTEM_BROADCAST.getPosition(self)
	return self.position
end

-- {消息类型}
function ACK_SYSTEM_BROADCAST.getBroadcastId(self)
	return self.broadcast_id
end

-- {消息数量}
function ACK_SYSTEM_BROADCAST.getMsgCount(self)
	return self.msg_count
end

-- {信息块(811)}
function ACK_SYSTEM_BROADCAST.getData(self)
	return self.data
end
