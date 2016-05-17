
require "common/AcknowledgementMessage"

-- (手动) -- [4200]系统推荐好友 -- 好友 

ACK_FRIEND_SYS_FRIEND = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_SYS_FRIEND
	self:init()
end)

function ACK_FRIEND_SYS_FRIEND.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {玩家数量}
	--self.data = reader:readXXXGroup() -- {系统推荐好友信息块（4025）}
    if self.count > 0 then
        self.data = {}
        
        for i=1, self.count do
            self.data[i] = {}
            
            self.data[i].fid        = reader:readInt32Unsigned()
            self.data[i].fname      = reader:readString()
            self.data[i].fclan      = reader:readInt8Unsigned()
            self.data[i].flv        = reader:readInt8Unsigned()
            self.data[i].isonline   = reader:readInt16Unsigned()
            self.data[i].pro        = reader:readInt8Unsigned()
            print("系统推荐好友信息块",self.data[i].fname)
        end
    end
    print("self.count669922",self.count)
end

-- {玩家数量}
function ACK_FRIEND_SYS_FRIEND.getCount(self)
	return self.count
end

-- {系统推荐好友信息块（4025）}
function ACK_FRIEND_SYS_FRIEND.getData(self)
	return self.data
end
