
require "common/AcknowledgementMessage"

-- [4060]查找好友返回 -- 好友 

ACK_FRIEND_SEARCH_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_SEARCH_REPLY
	self:init()
end)

function ACK_FRIEND_SEARCH_REPLY.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.data = reader:readXXXGroup() -- {信息块(4025)}
    print( "ACK_FRIEND_SEARCH_REPLY.deserialize", self.count)
    
    if self.count > 0 then
        self.data = {}
        
        for i=1, self.count do
            self.data[i] = {}
            
            self.data[i].fid        = reader:readInt32Unsigned()
            self.data[i].fname      = reader:readString()
            self.data[i].fclan      = reader:readString()
            self.data[i].flv        = reader:readInt8Unsigned()
            self.data[i].isonline   = reader:readInt16Unsigned()
            self.data[i].pro        = reader:readInt8Unsigned()
        end
    end
    print( "ACK_FRIEND_SEARCH_REPLY.deserialize", self.count)
    if self.data then
        for k, v in pairs( self.data) do
            print("self.data", k, v.fid, v.fname, type(v.fclan), v.flv, v.isonline)
        end
    else
        --CCMessageBox( "没有该玩家", "" )
        CCLOG("codeError!!!! 没有该玩家")
    end
end

-- {数量}
function ACK_FRIEND_SEARCH_REPLY.getCount(self)
	return self.count
end

-- {信息块(4025)}
function ACK_FRIEND_SEARCH_REPLY.getData(self)
	return self.data
end
