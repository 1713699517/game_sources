
require "common/AcknowledgementMessage"

-- (手动) -- [4020]返回好友信息 -- 好友 

ACK_FRIEND_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_INFO
	self:init()
end)

function ACK_FRIEND_INFO.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {返回好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
	self.count = reader:readInt16Unsigned() -- {好友数量}
	--self.data = reader:readXXXGroup() -- {好友信息块}
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
        end
    end
    
end

-- {返回好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
function ACK_FRIEND_INFO.getType(self)
	return self.type
end

-- {好友数量}
function ACK_FRIEND_INFO.getCount(self)
	return self.count
end

-- {好友信息块}
function ACK_FRIEND_INFO.getData(self)
	return self.data
end
